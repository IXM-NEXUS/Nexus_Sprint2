trigger labelupdate on case(before update){
    List<Case> csList=new List<Case>();
    List<String> oldLabel=new List<String>();
    List<String> newLabel = new List<String>();
    
    if(trigger.isupdate){
        for (Case cs : trigger.new){
            
            if((cs.labels__c != '' || cs.labels__c != null) && (cs.test_labels_1__c == '' || cs.test_labels_1__c == null)){
                cs.test_labels_1__c =cs.labels__c.replace(',', ';');
                //cs.test_labels_1__c =cs.labels__c;
                
           }
            
            //newLabel.add(cs.test_labels_1__c);
            
            
            
        }
        
        case casnew = trigger.new.get(0);
        newLabel.add(casnew.test_labels_1__c);
        
        case ca = trigger.old.get(0);
        oldLabel.add(ca.test_labels_1__c);
        
        /*for (Case cs : trigger.old){
            
            oldLabel.add(cs.test_labels_1__c);
            
            
            
        }*/
        
        system.debug('newLabel'+newLabel);
        system.debug('oldLabel'+oldLabel);
    }
}