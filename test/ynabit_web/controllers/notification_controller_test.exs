defmodule YnabitWeb.NotificationControllerTest do
  use YnabitWeb.ConnCase

  alias Ynabit.Sources
  # alias Ynabit.Sources.Notification

  @notification %{
    "SPF" => "pass",
    "attachments" => "0",
    "charsets" =>
      "{\"to\":\"UTF-8\",\"html\":\"UTF-8\",\"subject\":\"UTF-8\",\"from\":\"UTF-8\",\"text\":\"UTF-8\"}",
    "dkim" => "{@gmail.com : pass}",
    "envelope" => "{\"to\":[\"user@ynabit.com\"],\"from\":\"tomdoe@gmail.com\"}",
    "from" => "Tom Doe <tomdoe@gmail.com>",
    "headers" =>
      "Received: by mx0017p1las1.sendgrid.net with SMTP id 686z2W9CSv Wed, 28 Nov 2018 14:01:40 +0000 (UTC)\nReceived: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45]) by mx0017p1las1.sendgrid.net (Postfix) with ESMTPS id 3B42F4462B2 for <user@ynabit.com>; Wed, 28 Nov 2018 14:01:40 +0000 (UTC)\nReceived: by mail-ot1-f45.google.com with SMTP id a11so23552720otr.10 for <user@ynabit.com>; Wed, 28 Nov 2018 06:01:40 -0800 (PST)\nDKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025; h=mime-version:references:in-reply-to:reply-to:from:date:message-id :subject:to; bh=HUkIb5NglbHJyV+CfaS42rlvJmzYdJbCUvQkvh9oE0M=; b=GhQXxmDHaTtGw7FBY7VURotGVUlUAKv09H4oHyDjd+tA6k63EJdAwkKddeqbts4gKo TAODQ/B0YZsfMhtoNIiybqrJFlxnxw4ClqREGRr2zEkSKPTapPPBRyaUEnpyRBd0HuyF sAfyICmyjzhbWEP0rrLw/q0o/ZOohl0NGF3sOckR7LB0SyQ7EPv2nCr8/pgsXXb0up/U v9dnaNu+30VoKWb/l850jP9wjTvO8MlH2Cxrw0A4gHnGNr69p9p1ncrbo05F7QpqPnZk 10Stw2+X7opRDFXSptSxS2NiHV2SV8QmT0Mic5eVMV3WjsXKT2EQW0d/N0lILTVi6oqC onDw==\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20161025; h=x-gm-message-state:mime-version:references:in-reply-to:reply-to :from:date:message-id:subject:to; bh=HUkIb5NglbHJyV+CfaS42rlvJmzYdJbCUvQkvh9oE0M=; b=EmQAjCi9vXmX3kCfSjAVu+vg+yPNAtnf0ucl7emOnPnSgdDNMiAe36m6+QatPeT+tZ XP+aDzLeHUQH6byFLnaWLac2C8FdAFx4rFaJwFGPls+1Gz3cdIqLaW28ZVNypfGaegfY vF1WFlOhsTKgwKEX/POhp10UR4q+85+4yiEv2YeDeEQMa7Ndsw/KdIHkFdaAZolm2qBJ CZcDDYC7CTx7vLTIjGDddaAXCbQKBrXUxNTuGuUy3qzFnfyM/Qnhcp/sKSLz5oJDd4wZ 5k//D20sF0OTN7eCBu543dG72+VJzW6cu0+d6aGVNGWTcJbMbwByv0wyqTuLVOLyzKhL 939w==\nX-Gm-Message-State: AA+aEWboAVIb7/1KiYCr4MadPzjHQsI0k8oqXlXQcKXU6wDxCdJ/RLBx iwyRQC4Y37a2YpNg1aFfKzjOJdreB906pH0AMFsi5A==\nX-Google-Smtp-Source: AFSGD/VuqegnoL0kgJ7t5LMpvqooMg+n9H+09Q+ntGQsLMTzHEN/Mk9k2/zReK5svmExcMhMxayeXClB0fS/T2XuES8=\nX-Received: by 2002:a9d:84e:: with SMTP id 72mr20008273oty.203.1543413699150; Wed, 28 Nov 2018 06:01:39 -0800 (PST)\nMIME-Version: 1.0\nReferences: <SADGCISMALeyNtqMk7L00066558@sadgcismal.davivienda.loc>\nIn-Reply-To: <SADGCISMALeyNtqMk7L00066558@sadgcismal.davivienda.loc>\nReply-To: tomdoe@gmail.com\nFrom: Tom Doe <tomdoe@gmail.com>\nDate: Wed, 28 Nov 2018 09:01:28 -0500\nMessage-ID: <CAMhaS0pGa2+0ZKz7K3DgoQcm7kf9=njpM9kozu_tF+Hr+Dsy8w@mail.gmail.com>\nSubject: Fwd: DAVIVIENDA\nTo: user@ynabit.com\nContent-Type: multipart/alternative; boundary=\"000000000000478c29057bba0148\"\n",
    "html" =>
      "<div dir=\"ltr\"><br clear=\"all\"><div><div dir=\"ltr\" class=\"gmail_signature\" data-smartmail=\"gmail_signature\"><div dir=\"ltr\">--<div>Tom Doe</div></div></div></div><br><br><div class=\"gmail_quote\"><div dir=\"ltr\">---------- Forwarded message ---------<br>From: <span dir=\"ltr\">&lt;<a href=\"mailto:BANCO_DAVIVIENDA@davivienda.com\">BANCO_DAVIVIENDA@davivienda.com</a>&gt;</span><br>Date: Tue, Nov 27, 2018 at 7:33 PM<br>Subject: DAVIVIENDA<br>To:  &lt;<a href=\"mailto:tomdoe@gmail.com\">tomdoe@gmail.com</a>&gt;<br></div><br><br>Apreciado(a) Tom Doe: <br>\n<br>\nLe  informamos que se ha registrado el siguiente movimiento de su Tarjeta Crédito terminada en ****2020:<br>\n<br>\nFecha: 2018/11/28 <br>\nHora: 5:32:56 <br>\nValor Transacción: 7,409 <br>\nClase de Movimiento: Compra <br>\nRespuesta: Aprobado(a) <br>\nLugar de Transacción: UBER   *TRIP-WL2SO <br>\n<br>\nBANCO DAVIVIENDA<br>\nAVISO LEGAL : Este mensaje es confidencial, puede contener<br>\ninformación privilegiada y no puede ser usado ni divulgado por<br>\npersonas distintas de su destinatario. Si obtiene esta transmisión<br>\npor error, por favor destruya su contenido y avise a su remitente.<br>\nesta prohibida su retención, grabación, utilización, aprovechamiento<br>\no divulgación con cualquier propósito. Este mensaje ha sido sometido<br>\na programas antivirus. No obstante, el BANCO DAVIVIENDA S.A. y sus FILIALES   no<br>\nasumen ninguna responsabilidad por eventuales daños generados por <br>\nel recibo y el uso de este material, siendo responsabilidad del destinatario<br>\nverificar con sus propios medios la existencia de virus u otros<br>\ndefectos. El presente correo electrónico solo refleja la opinión de<br>\nsu Remitente y no representa necesariamente la opinión oficial del<br>\nBANCO DAVIVIENDA S.A. y sus FILIALES  o de sus Directivos<br>\n<br>\n</div></div>\n",
    "sender_ip" => "209.85.210.45",
    "subject" => "Fwd: DAVIVIENDA",
    "text" =>
      "--\Tom Doe\n\n\n---------- Forwarded message ---------\nFrom: <BANCO_DAVIVIENDA@davivienda.com>\nDate: Tue, Nov 27, 2018 at 7:33 PM\nSubject: DAVIVIENDA\nTo: <tomdoe@gmail.com>\n\n\nApreciado(a) Tom Doe:\n\nLe  informamos que se ha registrado el siguiente movimiento de su Tarjeta\nCrédito terminada en ****2020:\n\nFecha: 2018/11/28\nHora: 5:32:56\nValor Transacción: 7,409\nClase de Movimiento: Compra\nRespuesta: Aprobado(a)\nLugar de Transacción: UBER   *TRIP-WL2SO\n\nBANCO DAVIVIENDA\nAVISO LEGAL : Este mensaje es confidencial, puede contener\ninformación privilegiada y no puede ser usado ni divulgado por\npersonas distintas de su destinatario. Si obtiene esta transmisión\npor error, por favor destruya su contenido y avise a su remitente.\nesta prohibida su retención, grabación, utilización, aprovechamiento\no divulgación con cualquier propósito. Este mensaje ha sido sometido\na programas antivirus. No obstante, el BANCO DAVIVIENDA S.A. y sus\nFILIALES   no\nasumen ninguna responsabilidad por eventuales daños generados por\nel recibo y el uso de este material, siendo responsabilidad del destinatario\nverificar con sus propios medios la existencia de virus u otros\ndefectos. El presente correo electrónico solo refleja la opinión de\nsu Remitente y no representa necesariamente la opinión oficial del\nBANCO DAVIVIENDA S.A. y sus FILIALES  o de sus Directivos\n",
    "to" => "user@ynabit.com"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
