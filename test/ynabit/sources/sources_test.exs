defmodule Ynabit.SourcesTest do
  use Ynabit.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Ynabit.Sources
  alias Ynabit.Sources.Notification
  alias Ynabit.Accounts
  alias Ynabit.Accounts.Account

  @email %{
    "bcc" => %{
      "email" => "someuser@ynabit.com",
      "full" => "someuser@ynabit.com",
      "host" => "ynabit.com",
      "name" => nil,
      "token" => "someuser"
    },
    "text" =>
      "--\Tom Doe\n\n\n---------- Forwarded message ---------\nFrom: <BANCO_DAVIVIENDA@davivienda.com>\nDate: Tue, Nov 27, 2018 at 7:33 PM\nSubject: DAVIVIENDA\nTo: <tomdoe@gmail.com>\n\n\nApreciado(a) Tom Doe:\n\nLe  informamos que se ha registrado el siguiente movimiento de su Tarjeta\nCrédito terminada en ****2020:\n\nFecha: 2018/11/28\nHora: 5:32:56\nValor Transacción: 7,409\nClase de Movimiento: Compra\nRespuesta: Aprobado(a)\nLugar de Transacción: UBER   *TRIP-WL2SO\n\nBANCO DAVIVIENDA\nAVISO LEGAL : Este mensaje es confidencial, puede contener\ninformación privilegiada y no puede ser usado ni divulgado por\npersonas distintas de su destinatario. Si obtiene esta transmisión\npor error, por favor destruya su contenido y avise a su remitente.\nesta prohibida su retención, grabación, utilización, aprovechamiento\no divulgación con cualquier propósito. Este mensaje ha sido sometido\na programas antivirus. No obstante, el BANCO DAVIVIENDA S.A. y sus\nFILIALES   no\nasumen ninguna responsabilidad por eventuales daños generados por\nel recibo y el uso de este material, siendo responsabilidad del destinatario\nverificar con sus propios medios la existencia de virus u otros\ndefectos. El presente correo electrónico solo refleja la opinión de\nsu Remitente y no representa necesariamente la opinión oficial del\nBANCO DAVIVIENDA S.A. y sus FILIALES  o de sus Directivos\n"
  }
  @valid_attrs %{payload: %{}, processed: true, raw: @email}
  @update_attrs %{payload: %{}, processed: false, raw: @email}
  @invalid_attrs %{payload: nil, processed: nil, raw: nil}

  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Sources.create_notification()

    notification
  end

  describe "notifications" do
    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Sources.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Sources.get_notification!(notification.id) == notification
    end

    test "parse_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Sources.parse_notification(@email)

      assert notification.payload == %{
               amount: -7409,
               approved: true,
               cleared: "cleared",
               date: "2018-11-28",
               import_id: "F6E2DE772440935C7AA43863ABB10C58",
               payee_name: "UBER   *TRIP-WL2SO"
             }

      assert notification.processed == true
      assert notification.raw == @email
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()

      assert {:ok, %Notification{} = notification} =
               Sources.update_notification(notification, @update_attrs)

      assert notification.payload == %{}
      assert notification.processed == false
      assert notification.raw == @email
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Sources.update_notification(notification, @invalid_attrs)

      assert notification == Sources.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Sources.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_notification!(notification.id) end
    end

    test "normalize_payload/1 replaces payee_name and adds memo field" do
      payload = %{
        amount: -7409,
        approved: true,
        cleared: "cleared",
        date: "2018-11-28",
        import_id: "F6E2DE772440935C7AA43863ABB10C58",
        payee_name: "UBER   *TRIP-WL2SO"
      }

      assert Sources.normalize_payload(payload) == %{
               amount: -7_409_000,
               approved: true,
               cleared: "cleared",
               date: "2018-11-28",
               import_id: "F6E2DE772440935C7AA43863ABB10C58",
               payee_name: "UBER",
               memo: "UBER   *TRIP-WL2SO"
             }
    end

    test "find_payee/1 return payee name if there is a match" do
      assert Sources.find_payee("UBER   *TRIP-WL2SO") == {:ok, "UBER"}
      assert Sources.find_payee("CREPES Y WAFFLES OVIEDO") == {:ok, "CREPES Y WAFFLES"}
      assert Sources.find_payee("PIZZERIA OLIVIA SANTAFE") == {:ok, "PIZZERIA OLIVIA"}
      assert Sources.find_payee("PAYU NETFLIX") == {:ok, "NETFLIX"}
      assert Sources.find_payee("CARULLA PAULO") == {:ok, "CARULLA"}
      assert Sources.find_payee("CARULLA PAULO") == {:ok, "CARULLA"}
      assert Sources.find_payee("FIRE HOUSE MILLA DE OR ") == {:ok, "FIRE HOUSE"}
      assert Sources.find_payee("Spotify P0adfadf") == {:ok, "Spotify"}
      assert Sources.find_payee("HEROKU *NOV-22222") == {:ok, "Heroku"}
    end
  end

  describe "#post_notification_to_ynab" do
    test "post transaction to YNAB" do
      {:ok, %Account{} = account} =
        Accounts.create_account(%{
          account_id: "1d1d0041-b3ea-46d9-a148-ce2b9d3f22a2",
          api_token: "be491e15565bbd4340cab569ec1aa7509ba7d3f57cd42e7a66e20f0dd49372a0",
          budget_id: "bf9a36ca-f77c-44a2-959f-c942a78f2c74",
          slug: "someuser"
        })

      {:ok, notification} = Sources.parse_notification(@email)

      use_cassette "new_transaction" do
        assert {:ok, response} = Sources.post_notification_to_ynab(notification)

        assert Jason.decode(response.request.body) ==
                 {:ok,
                  %{
                    "transaction" => %{
                      "account_id" => account.account_id,
                      "amount" => -7_409_000,
                      "approved" => true,
                      "cleared" => "cleared",
                      "date" => "2018-11-28",
                      "import_id" => "F6E2DE772440935C7AA43863ABB10C58",
                      "memo" => "UBER   *TRIP-WL2SO",
                      "payee_name" => "UBER"
                    }
                  }}

        assert Enum.into(response.request.headers, %{})["Authorization"] ==
                 "Bearer " <> account.api_token

        assert response.request_url ==
                 "https://api.youneedabudget.com/v1/budgets/" <>
                   account.budget_id <> "/transactions"

        assert response.status_code == 201
      end
    end
  end
end
