public class SendRMAApprovalMessage{
    @InvocableMethod
    public static void sendRMApprovalEmail(List<Case> listCase) {
        if(listCase != null && listCase.size() > 0){
            Case currentCase = listCase.get(0);
            System.debug('currentCase 0: ' + currentCase.Id);
            System.debug('currentCase contactid ::: ' + currentCase.contactid); 
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                List<string> toAddress = new List<string>();
                List<string> ccAddress = new List<string>();
                toAddress.add('skapadia@invixium.com');
                toAddress.add('dpatel@invixium.com');
                //toAddress.add('narendra.rana@sftpl.com');
                
                ccAddress.add('dhakke@invixium.com');
                String emailTemplateName='VF_RMA_Approval';
                EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'VF_RMA_Approval'];

                mail.setTargetObjectId(UserInfo.getUserId()); 
                mail.setToAddresses(toAddress);
                //Change with Template ID
                mail.setTemplateId(emailTemplate.Id); 
                
                //Record ID for which letter will be generated
                mail.setWhatId(currentCase.Id); 
                mail.setBccSender(false); 
                mail.setUseSignature(false); 
                mail.setSenderDisplayName('Card Division'); 
                mail.setSaveAsActivity(false);
    
                
                system.debug('@@@ Current Email Body ::' + mail.getHTMLBody());
                
                List<Emailmessage> listEM = [select id, htmlbody, textbody from Emailmessage where parentid =: currentCase.Id order by createddate desc];
                
                String pastEmailMessage = '';
                if(listEM != null && listEM.size() > 0){
                    pastEmailMessage = listEM.get(0).htmlbody;
                }
                system.debug('@@@ pastEmailMessage :::' + pastEmailMessage);
                
                
                // Send the emails in a transaction, then roll it back
                Savepoint sp = Database.setSavepoint();
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Database.rollback(sp);
                System.debug('@@ currentEmailBody :::' + mail.getHTMLBody());
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                
                //email.setTargetObjectId(currentCase.contactid );
                email.setSubject(emailTemplate.subject);
                email.setWhatId(currentCase.Id);
                email.setToAddresses(toAddress);
                email.setCcAddresses(ccAddress);
                email.setHtmlBody(mail.getHTMLBody() + pastEmailMessage);
                email.setSaveAsActivity(true);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }catch(Exception error){
                system.debug('Error in sending approval Email ::' + error);
            }
        }
    }
}