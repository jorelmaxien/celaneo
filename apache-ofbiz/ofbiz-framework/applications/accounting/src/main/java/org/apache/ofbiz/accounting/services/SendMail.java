package org.apache.ofbiz.accounting.services;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendMail {

    private Session session = null;
    private Transport transport = null;

    /**
     * Fixer les propriétés
     */
    public void connect(String host, String user, String password, String port) throws NoSuchProviderException, MessagingException {
        Properties properties = new Properties();
        properties.setProperty("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.auth", "true");
         properties.setProperty("mail.smtp.port", port);
        this.session = Session.getDefaultInstance(properties, null);
        this.transport = this.session.getTransport();
        this.transport.connect(host, user, password);
    }

    public void send(String from, String to, String subject, String body) throws MessagingException {
        MimeMessage message = new MimeMessage(this.session);
        message.setSubject(subject);
        message.setContent(body, "text/plain");
        message.addRecipient(Message.RecipientType.TO,  new InternetAddress(to));
        message.setFrom(new InternetAddress(from));
        this.transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
        this.transport.close();
    }

    public void sendConf(String to, String subject, String body) throws MessagingException {

        this.connect(configurationParam.HOST_MAIL,configurationParam.USER_MAIL,configurationParam.PWD_MAIL,  configurationParam.PORT_MAIL);
       this.send(configurationParam.NAME_MAIL,to,subject,body);
    }
}
