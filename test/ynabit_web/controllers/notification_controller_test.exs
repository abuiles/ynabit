defmodule YnabitWeb.NotificationControllerTest do
  use YnabitWeb.ConnCase

  alias Ynabit.Sources
  # alias Ynabit.Sources.Notification

  @notification %{
    "text" =>
      "--\Tom Doe\n\n\n---------- Forwarded message ---------\nFrom: <BANCO_DAVIVIENDA@davivienda.com>\nDate: Tue, Nov 27, 2018 at 7:33 PM\nSubject: DAVIVIENDA\nTo: <tomdoe@gmail.com>\n\n\nApreciado(a) Tom Doe:\n\nLe  informamos que se ha registrado el siguiente movimiento de su Tarjeta\nCrédito terminada en ****2020:\n\nFecha: 2018/11/28\nHora: 5:32:56\nValor Transacción: 7,409\nClase de Movimiento: Compra\nRespuesta: Aprobado(a)\nLugar de Transacción: UBER   *TRIP-WL2SO\n\nBANCO DAVIVIENDA\nAVISO LEGAL : Este mensaje es confidencial, puede contener\ninformación privilegiada y no puede ser usado ni divulgado por\npersonas distintas de su destinatario. Si obtiene esta transmisión\npor error, por favor destruya su contenido y avise a su remitente.\nesta prohibida su retención, grabación, utilización, aprovechamiento\no divulgación con cualquier propósito. Este mensaje ha sido sometido\na programas antivirus. No obstante, el BANCO DAVIVIENDA S.A. y sus\nFILIALES   no\nasumen ninguna responsabilidad por eventuales daños generados por\nel recibo y el uso de este material, siendo responsabilidad del destinatario\nverificar con sus propios medios la existencia de virus u otros\ndefectos. El presente correo electrónico solo refleja la opinión de\nsu Remitente y no representa necesariamente la opinión oficial del\nBANCO DAVIVIENDA S.A. y sus FILIALES  o de sus Directivos\n",
    "bcc" => %{
      "email" => "someuser@ynabit.com",
      "full" => "someuser@ynabit.com",
      "host" => "ynabit.com",
      "name" => nil,
      "token" => "someuser"
    }
  }

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header("content-type", "multipart/form-data")}
  end

  describe "parse notification" do
    test "returns 204 regardless of the result", %{conn: conn} do
      conn = post(conn, Routes.notification_path(conn, :parse), @notification)

      assert response(conn, 204)
    end

    test "creates a new notification", %{conn: conn} do
      post(conn, Routes.notification_path(conn, :parse), @notification)

      assert length(Sources.list_notifications()) == 1
    end
  end
end
