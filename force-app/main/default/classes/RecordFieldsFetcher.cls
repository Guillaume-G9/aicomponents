/*
 * @description   This class is used to fetch all non-blank fields of a record and ask chat GPT to summarize.
 */

 public with sharing class RecordFieldsFetcher {

    //Exclude system fields
    private static List<String> excludedFields = new List<String>{
        'IsDeleted'.toUpperCase(),'MasterRecordId'.toUpperCase(),'Type'.toUpperCase(),'RecordTypeId'.toUpperCase(),'ParentId'.toUpperCase(),'BillingStreet'.toUpperCase(),'BillingCity'.toUpperCase(),'BillingState'.toUpperCase(),'BillingPostalCode'.toUpperCase(),'BillingCountry'.toUpperCase(),'BillingLatitude'.toUpperCase(),'BillingLongitude'.toUpperCase(),'BillingGeocodeAccuracy'.toUpperCase(),'BillingAddress'.toUpperCase(),'BillingAddress.city'.toUpperCase(),'BillingAddress.country'.toUpperCase(),'BillingAddress.geocodeAccuracy'.toUpperCase(),'BillingAddress.latitude'.toUpperCase(),'BillingAddress.longitude'.toUpperCase(),'BillingAddress.postalCode'.toUpperCase(),'BillingAddress.state'.toUpperCase(),'BillingAddress.street'.toUpperCase(),'ShippingStreet'.toUpperCase(),'ShippingCity'.toUpperCase(),'ShippingState'.toUpperCase(),'ShippingPostalCode'.toUpperCase(),'ShippingCountry'.toUpperCase(),'ShippingLatitude'.toUpperCase(),'ShippingLongitude'.toUpperCase(),'ShippingGeocodeAccuracy'.toUpperCase(),'ShippingAddress'.toUpperCase(),'ShippingAddress.city'.toUpperCase(),'ShippingAddress.country'.toUpperCase(),'ShippingAddress.geocodeAccuracy'.toUpperCase(),'ShippingAddress.latitude'.toUpperCase(),'ShippingAddress.longitude'.toUpperCase(),'ShippingAddress.postalCode'.toUpperCase(),'ShippingAddress.state'.toUpperCase(),'ShippingAddress.street'.toUpperCase(),'Phone'.toUpperCase(),'Fax'.toUpperCase(),'AccountNumber'.toUpperCase(),'Website'.toUpperCase(),'PhotoUrl'.toUpperCase(),'Sic'.toUpperCase(),'Industry'.toUpperCase(),'AnnualRevenue'.toUpperCase(),'NumberOfEmployees'.toUpperCase(),'TickerSymbol'.toUpperCase(),'Description'.toUpperCase(),'Rating'.toUpperCase(),'Site'.toUpperCase(),'CurrencyIsoCode'.toUpperCase(),'OwnerId'.toUpperCase(),'CreatedDate'.toUpperCase(),'CreatedById'.toUpperCase(),'LastModifiedDate'.toUpperCase(),'LastModifiedById'.toUpperCase(),'SystemModstamp'.toUpperCase(),'LastActivityDate'.toUpperCase(),'LastViewedDate'.toUpperCase(),'LastReferencedDate'.toUpperCase(),'IsCustomerPortal'.toUpperCase(),'Jigsaw'.toUpperCase(),'JigsawCompanyId'.toUpperCase(),'AccountSource'.toUpperCase(),'SicDesc'.toUpperCase(),'ActivityMetricId'.toUpperCase(),'ActivityMetricRollupId'.toUpperCase(),'ALPHONSE_API_domains__c'.toUpperCase(),'ALPHONSE_Lifen_ID__c'.toUpperCase(),'ALPHONSE_Status__c'.toUpperCase(),'ALPHONSE_WorkspaceID__c'.toUpperCase(),'Account_Type_Icon__c'.toUpperCase(),'Accountmanager__c'.toUpperCase(),'ApicryptAddress__c'.toUpperCase(),'BillingEmailAddress__c'.toUpperCase(),'BillingType__c'.toUpperCase(),'ContactPreferences__c'.toUpperCase(),'ContractSentDate__c'.toUpperCase(),'ContractSignedDate__c'.toUpperCase(),'ContractSigned__c'.toUpperCase(),'Country__c'.toUpperCase(),'DWH_Count_of_Report_received__c'.toUpperCase(),'DWH_Count_of_Report_sent__c'.toUpperCase(),'DeploymentStatus__c'.toUpperCase(),'DoctolibActivityCessation__c'.toUpperCase(),'DoctolibExpertiseUpdateDate__c'.toUpperCase(),'DoctolibExpertise__c'.toUpperCase(),'DoctolibScrapingDate__c'.toUpperCase(),'DoctolibTeleconsultation__c'.toUpperCase(),'DoctolibUser__c'.toUpperCase(),'ETL_Region__c'.toUpperCase(),'ETL_departement__c'.toUpperCase(),'EligibleForDeployment__c'.toUpperCase(),'ExternalSecretariat__c'.toUpperCase(),'GHT_Code__c'.toUpperCase(),'HUBSPOT_Company_ID__c'.toUpperCase(),'IdentityStatus__c'.toUpperCase(),'Identity_lookup__c'.toUpperCase(),'MSSAddress__c'.toUpperCase(),'NESTOR_CategoryName__c'.toUpperCase(),'KAM_Owner__c'.toUpperCase(),'NESTOR_FINESS_geo__c'.toUpperCase(),'NESTOR_FINESS_legal__c'.toUpperCase(),'NESTOR_First_Name__c'.toUpperCase(),'NESTOR_Last_Name__c'.toUpperCase(),'NESTOR_LifenReference__c'.toUpperCase(),'NESTOR_OrganizationID__c'.toUpperCase(),'NESTOR_Organization_Source__c'.toUpperCase(),'NESTOR_PractitionerID__c'.toUpperCase(),'NESTOR_ProfessionName__c'.toUpperCase(),'NESTOR_SIREN_Site__c'.toUpperCase(),'NESTOR_SIRET_Site__c'.toUpperCase(),'NESTOR_Source__c'.toUpperCase(),'NESTOR_SpecialtyName__c'.toUpperCase(),'NESTOR_Typeof__c'.toUpperCase(),'ProfessionCompactLayout__c'.toUpperCase(),'NESTOR_parentabletype__c'.toUpperCase(),'Nestor_ID__c'.toUpperCase(),'Nestor_Status__c'.toUpperCase(),'PDFCreatorLicenceExpiration__c'.toUpperCase(),'PotentialUpsell__c'.toUpperCase(),'Practitioners_activity_type__c'.toUpperCase(),'SecondIndustry__c'.toUpperCase(),'TECH_Record_Type_Name__c'.toUpperCase(),'ThirdIndustry__c'.toUpperCase(),'Type_Business__c'.toUpperCase(),'Type_CareProvider__c'.toUpperCase(),'Type_Healthcare__c'.toUpperCase(),'Type_Institutional__c'.toUpperCase(),'Type_SecteurHospitalier__c'.toUpperCase(),'ClosedDeployment__c'.toUpperCase(),'TotalDeployment__c'.toUpperCase(),'ALPHONSE_IsOrganization__c'.toUpperCase(),'AccountTemporaryRelationID__c'.toUpperCase(),'ChurnAlert__c'.toUpperCase(),'Department_Loyalty_Owner__c'.toUpperCase(),'Loyalty_Owner__c'.toUpperCase(),'NESTOR_Created_date__c'.toUpperCase(),'NESTOR_NationalIdentifierType__c'.toUpperCase(),'NESTOR_NationalIdentifier__c'.toUpperCase(),'NESTOR_Updated_date__c'.toUpperCase(),'NESTOR_version__c'.toUpperCase(),'Manually_created_Alphonse__c'.toUpperCase(),'Manually_created_in_Alphonse_by__c'.toUpperCase(),'ChurnRatio__c'.toUpperCase(),'Success_Journey__c'.toUpperCase(),'ClientRatio__c'.toUpperCase(),'Sender_Profil__c'.toUpperCase(),'NumberofReportsReceivedlast30day__c'.toUpperCase(),'NumberofReportsReceivedlast90day__c'.toUpperCase(),'NumberofReportsSentlast30days__c'.toUpperCase(),'NumberofReportsSentlast90days__c'.toUpperCase(),'PractitionerGroup__c'.toUpperCase(),'Lifecycle__c'.toUpperCase(),'Identity_Reports_Sent_last_30_days__c'.toUpperCase(),'Identity_Reports_Sent_last_90_days__c'.toUpperCase(),'GHTMainOrganization__c'.toUpperCase(),'InternalGroup__c'.toUpperCase(),'Trigram__c'.toUpperCase(),'HeadquarterGroup__c'.toUpperCase(),'SJ_Count__c'.toUpperCase(),'Team_Ownership__c'.toUpperCase(),'Last_AM_Action__c'.toUpperCase(),'Secretariat_physically_in_the_Clinic__c'.toUpperCase(),'FHIR_ID__c'.toUpperCase(),'DeploymentEligibility__c'.toUpperCase(),'GroupN1__c'.toUpperCase(),'GroupN2__c'.toUpperCase(),'GroupN3__c'.toUpperCase(),'GroupN4__c'.toUpperCase(),'GroupN5__c'.toUpperCase(),'GroupN6__c'.toUpperCase(),'GroupN7__c'.toUpperCase(),'NumberOfChurnedPratActivity__c'.toUpperCase(),'NumberOfClientPratActivity__c'.toUpperCase(),'NumberOfPratActivity__c'.toUpperCase(),'NumberOfProspectedPratActivity__c'.toUpperCase(),'FinalAMaction__c'.toUpperCase(),'ALPHONSE_CreatedDate__c'.toUpperCase(),'ALPHONSE_EndDate__c'.toUpperCase(),'ALPHONSE_ID__c'.toUpperCase(),'ALPHONSE_Purpose__c'.toUpperCase(),'API_Domain__c'.toUpperCase(),'Count_SJ__c'.toUpperCase(),'NumberofReportsReceivedAllTime__c'.toUpperCase(),'NumberofReportsSentAllTime__c'.toUpperCase(),'App_Personas__c'.toUpperCase(),'Businessmodel__c'.toUpperCase(),'CountofHealthcareInstitutionClients__c'.toUpperCase(),'CountofPatientUsers__c'.toUpperCase(),'CountofPrivatePractitionerUsers__c'.toUpperCase(),'Identity_Reports_Received_All_Time__c'.toUpperCase(),'Identity_Reports_Sent_All_Time__c'.toUpperCase(),'InternationalPresence__c'.toUpperCase(),'OtherPersonas__c'.toUpperCase(),'OtherTech__c'.toUpperCase(),'Tech__c'.toUpperCase(),'OtherBusinessType__c'.toUpperCase(),'First_Reception_Date__c'.toUpperCase(),'First_Sending_Date__c'.toUpperCase(),'Has_Active_Campaign__c'.toUpperCase(),'Identity_First_Reception_Date__c'.toUpperCase(),'Identity_First_Sending_Date__c'.toUpperCase(),'NESTOR_APE__c'.toUpperCase(),'NESTOR_CATEGORY_AGREGAT__c'.toUpperCase(),'NESTOR_CATEGORY__c'.toUpperCase(),'NESTOR_MFTREAD__c'.toUpperCase(),'NESTOR_MFT__c'.toUpperCase(),'NESTOR_SPHREAD__c'.toUpperCase(),'NESTOR_SPH__c'.toUpperCase(),'NESTOR_STATUT_JURIDIQUEREAD__c'.toUpperCase(),'NESTOR_STATUT_JURIDIQUE__c'.toUpperCase(),'SegurVerticale__c'.toUpperCase(),'NESTOR_Certified__c'.toUpperCase(),'Account_Manager_Full_Name__c'.toUpperCase(),'Created_Automatically_by_Carlo__c'.toUpperCase(),'NESTOR_CATEGORYREAD__c'.toUpperCase(),'NESTOR_CATEGORY_AGREGATREAD__c'.toUpperCase(),'DepartementSource__c'.toUpperCase(),'Departement__c'.toUpperCase(),'RegionSource__c'.toUpperCase(),'Region__c'.toUpperCase(),'StatutJurNum__c'.toUpperCase(),'StatutOrganismeParent__c'.toUpperCase(),'StatutOrganisme__c'.toUpperCase(),'HubCreatedDate__c'.toUpperCase(),'HubLink__c'.toUpperCase(),'Business_Subtype__c'.toUpperCase(),'Business_Type2__c'.toUpperCase(),'Employee_Range__c'.toUpperCase(),'Founded_Year__c'.toUpperCase(),'Linkedin_Page__c'.toUpperCase(),'Total_funds_raised__c'.toUpperCase(),'AlphonseLastSyncBy__c'.toUpperCase(),'AlphonseLastSync__c'.toUpperCase(),'ParentOwnership__c'.toUpperCase(),'Identity_Number_of_DMP_sent_all_time__c'.toUpperCase(),'Identity_Number_of_DPI_sent_all_time__c'.toUpperCase(),'Identity_Number_of_PMSI_sent_all_time__c'.toUpperCase(),'NumberDMPDocSentAllTime__c'.toUpperCase(),'NumberDPIDocSentAllTime__c'.toUpperCase(),'NumberPMSIDocSentAllTime__c'.toUpperCase(),'Statut_Nestor__c'.toUpperCase(),'Allow_internal_sending__c'.toUpperCase(),'Allow_patient_sending__c'.toUpperCase(),'Allow_sending__c'.toUpperCase(),'Color_Printing__c'.toUpperCase(),'Direct_mail_authorized__c'.toUpperCase(),'Integration_lifen_references__c'.toUpperCase(),'Internal_sending_keywords__c'.toUpperCase(),'Multi_Recipient_Mode__c'.toUpperCase(),'NextCSMAction__c'.toUpperCase(),'Patient_automatic_resending__c'.toUpperCase(),'Ready_to_send_automatic_sending__c'.toUpperCase(),'automatic_sending__c'.toUpperCase(),'is_real_time_sender__c'.toUpperCase(),'Identity_Nbr_of_DMP_sent_last_30_days__c'.toUpperCase(),'Identity_Nbr_of_DMP_sent_last_90_days__c'.toUpperCase(),'Identity_Nbr_of_DPI_sent_last_30_days__c'.toUpperCase(),'Identity_Nbr_of_DPI_sent_last_90_days__c'.toUpperCase(),'Identity_Nbr_of_PMSI_sent_last_30_days__c'.toUpperCase(),'Identity_Nbr_of_PMSI_sent_last_90_days__c'.toUpperCase(),'NumberDMPDocSent30days__c'.toUpperCase(),'NumberDMPDocSent90days__c'.toUpperCase(),'NumberDPIDocSent30days__c'.toUpperCase(),'NumberDPIDocSent90days__c'.toUpperCase(),'NumberPMSIDocSent30days__c'.toUpperCase(),'NumberPMSIDocSent90days__c'.toUpperCase(),'RecordTypeName__c'.toUpperCase(),'SBQQ__AssetQuantitiesCombined__c'.toUpperCase(),'SBQQ__CoTermedContractsCombined__c'.toUpperCase(),'SBQQ__CoTerminationEvent__c'.toUpperCase(),'SBQQ__ContractCoTermination__c'.toUpperCase(),'SBQQ__DefaultOpportunity__c'.toUpperCase(),'SBQQ__IgnoreParentContractedPrices__c'.toUpperCase(),'SBQQ__PreserveBundle__c'.toUpperCase(),'SBQQ__PriceHoldEnd__c'.toUpperCase(),'SBQQ__RenewalModel__c'.toUpperCase(),'SBQQ__RenewalPricingMethod__c'.toUpperCase(),'SBQQ__TaxExempt__c'.toUpperCase(),'blng__BillToContact__c'.toUpperCase(),'blng__CustomerProfileId__c'.toUpperCase(),'blng__DefaultPaymentType__c'.toUpperCase(),'AutoSenderProfile__c'.toUpperCase(),'Sum_of_all_docs_sent_all_time__c'.toUpperCase(),'Sum_of_all_docs_sent_last_30_days__c'.toUpperCase(),'Sum_of_all_docs_sent_last_90_days__c'.toUpperCase(),'TauxPretEnvoi_AllTime__c'.toUpperCase(),'Equipped_with_a_biology_laboratory__c'.toUpperCase(),'Equipped_with_an_imaging_facility__c'.toUpperCase(),'Segur_Montant_DPI__c'.toUpperCase(),'Segur_Montant_Domaine_Biologie__c'.toUpperCase(),'Segur_Montant_Domaine_Imagerie__c'.toUpperCase(),'Segur_Montant_Domaine_documents_sortie__c'.toUpperCase(),'Segur_Montant_PFI__c'.toUpperCase(),'Segur_Montant_RI__c'.toUpperCase(),'Tranche_Segur__c'.toUpperCase(),'TauxPretEnvoi_30days__c'.toUpperCase(),'IdentityTauxPretEnvoi_30days__c'.toUpperCase(),'Churn_Type__c'.toUpperCase(),'IDentityTauxPretEnvoi_AllTime__c'.toUpperCase(),'Identity_Churn_Range__c'.toUpperCase(),'Identity_SpecialtyName__c'.toUpperCase(),'RelatedLocation__c'.toUpperCase(),'Identity_FHIR_ID__c'.toUpperCase(),'First_Integration_Date__c'.toUpperCase(),'Identity_First_Integration_Date__c'.toUpperCase(),'DataStreamUpdatedDate__c'.toUpperCase(),'Segur_Montant_Financement_Usage_Volet2__c'.toUpperCase(),'UsageUpdatedDate__c'.toUpperCase(),'SFBD__CollectionsAgent__c'.toUpperCase(),'SFBD__CollectionsPlanDate__c'.toUpperCase(),'SFBD__CollectionsStatus__c'.toUpperCase(),'SFBD__DunningMethod__c'.toUpperCase(),'SFBD__SLA__c'.toUpperCase(),'SFBD__UpsellOpportunity__c'.toUpperCase(),'PractitionersBillingPoolGroup__c'.toUpperCase(),'REV_Billing_Contact__c'.toUpperCase(),'REV_Is_Old_Clinic__c'.toUpperCase(),'REV_Mutualisation__c'.toUpperCase(),'REV_Order__c'.toUpperCase(),'REV_PractitionerFirstLoginDate__c'.toUpperCase(),'Related_PractitionersBillingPool__c'.toUpperCase(),'StripeId__c'.toUpperCase(),'Ajout_page_contenant_ins_envo__c'.toUpperCase(),'Utilisation_INS_Qualifie__c'.toUpperCase(),'Data_Quality_Description__c'.toUpperCase(),'Data_Quality_Score__c'.toUpperCase(),'GoCardlessId__c'.toUpperCase(),'LocationTauxPretEnvoi_30days__c'.toUpperCase(),'LocationTauxPretEnvoi_AllTime__c'.toUpperCase(),'CSM_Manager__c'.toUpperCase(),'PAY_Mandat_Link__c'.toUpperCase(),'Billing_CC__c'.toUpperCase(),'Billing_Pool_Type__c'.toUpperCase(),'Segur_BonusCRO__c'.toUpperCase(),'Segur_Volet1D1__c'.toUpperCase(),'Segur_Volet1D2__c'.toUpperCase(),'Segur_Volet1D3__c'.toUpperCase(),'Segur_Volet1FenetreSelectionnee__c'.toUpperCase(),'FINESS_PMSI__c'.toUpperCase(),'AccountPMSI__c'.toUpperCase(),'Account_PMSI__c'.toUpperCase(),'LastLoginDate__c'.toUpperCase(),'ETAPES_Program__c'.toUpperCase(),'Activation_de_la_cover_page__c'.toUpperCase(),'AllDocsSent30DaysLegalEntity__c'.toUpperCase(),'AllDocsSent30DaysLocation__c'.toUpperCase(),'AllDocsSentAllTimeLegalEntity__c'.toUpperCase(),'AllDocsSentAllTimeLocation__c'.toUpperCase(),'Docs_written_in_the_EHR__c'.toUpperCase(),'MainLocationCategory__c'.toUpperCase(),'REV_Send_Invoice__c'.toUpperCase(),'ReportsSent30DaysLegalEntity__c'.toUpperCase(),'ReportsSent30DaysLocation__c'.toUpperCase(),'ReportsSentAllTimeLegalEntity__c'.toUpperCase(),'ReportsSentAllTimeLocation__c'.toUpperCase(),'SendingVolumeLastMonthLegalEntity__c'.toUpperCase(),'SendingVolumeLastMonthLocation__c'.toUpperCase(),'DocsWrittenInTheEHR__c'.toUpperCase(),'SEGUR_Montant_DPI_HT__c'.toUpperCase(),'SEGUR_Montant_DPI_TTC__c'.toUpperCase(),'SEGUR_Montant_PFI_HT__c'.toUpperCase(),'SEGUR_Montant_PFI_TTC__c'.toUpperCase(),'SEGUR_Montant_RI_HT__c'.toUpperCase(),'SEGUR_Montant_RI_TTC__c'.toUpperCase(),'TieringReason__c'.toUpperCase(),'SEGUR_Volet1D1DocumentsDeSortieF1__c'.toUpperCase(),'SEGUR_Volet1D1DocumentsDeSortieF2__c'.toUpperCase(),'SEGUR_Volet1D1DocumentsDeSortieF3__c'.toUpperCase(),'SEGUR_Volet1D1DocumentsDeSortieF4__c'.toUpperCase(),'SEGUR_Volet1D2BiologieF1__c'.toUpperCase(),'SEGUR_Volet1D2BiologieF2__c'.toUpperCase(),'SEGUR_Volet1D2BiologieF3__c'.toUpperCase(),'SEGUR_Volet1D2BiologieF4__c'.toUpperCase(),'SEGUR_Volet1D3ImagerieF1__c'.toUpperCase(),'SEGUR_Volet1D3ImagerieF2__c'.toUpperCase(),'SEGUR_Volet1D3ImagerieF3__c'.toUpperCase(),'SEGUR_Volet1D3ImagerieF4__c'.toUpperCase(),'SEGUR_Volet2D4MssSanteProCitoyenneF1__c'.toUpperCase(),'SEGUR_Volet2D4MssSanteProCitoyenneF2__c'.toUpperCase(),'SEGUR_Volet2D4MssSanteProCitoyenneF3__c'.toUpperCase(),'SEGUR_Volet2D4MssSanteProCitoyenneF4__c'.toUpperCase(),'Segur_Volet2D4__c'.toUpperCase(),'Number_Order__c'.toUpperCase(),'PAY_ValidPaymentMethodId__c'.toUpperCase(),'Application_level__c'.toUpperCase(),'Number_of_Healthcare_Units__c'.toUpperCase(),'Onboarding_End_Date__c'.toUpperCase(),'IsAccountPMSI__c'.toUpperCase(),'Go_NoGo_Migration_Eugene__c'.toUpperCase(),'Factures_a_deposer_Chorus__c'.toUpperCase(),'BillingEntityName__c'.toUpperCase(),'ESPIC__c'.toUpperCase(),'STREAM_PractitionerExternalId__c'.toUpperCase(),'Client_Type__c'.toUpperCase(),'UpflowId__c'.toUpperCase(),'Account_Comment__c'.toUpperCase(),'Account_Display_Name__c'.toUpperCase(),'Created_From_Migration__c'.toUpperCase(),'INSCoverAuthorized__c'.toUpperCase(),'IS_Owner__c'.toUpperCase(),'FinanceId__c'.toUpperCase(),'Potential_ASD__c'.toUpperCase(),'Billing_Pool_Structure__c'.toUpperCase(),'CustomerUpflowId__c'.toUpperCase(),'Prio_Support__c'.toUpperCase(),'RIS__c'.toUpperCase(),'SGL__c'.toUpperCase(),'ICBCode__c'.toUpperCase(),'NHSTrustCode__c'.toUpperCase(),'REV_LegalEntity__c'.toUpperCase(),'Relance_Contact__c'.toUpperCase(),'Estimated_MRR_Lifen_Integration__c'.toUpperCase(),'DPI__c'.toUpperCase(),'GAM__c'.toUpperCase(),'Allow_multiple_licences_PDF_Creator__c'.toUpperCase(),'Split_Invoices__c'.toUpperCase(),'CHORUS_SIRET_destinataire__c'.toUpperCase(),'CHORUS_code_service__c'.toUpperCase(),'CHORUS_numero_engagement__c'.toUpperCase(),'CHORUS_numero_marche__c'.toUpperCase(),'Financial_scoring__c'.toUpperCase(),'Financial_scoring_comment__c'.toUpperCase(),'EAI__c'.toUpperCase(),'CHORUS_Comment__c'.toUpperCase()
    };

    //Consider only these child relationships
    private static List<String> childRelationships = new List<String>{
        'Opportunities', 'Parents_Deployment__r', 'Cases'
    };

    /**
     *  Returns the list of non-blank field names and values for the given record to LWC component.
     */
    @AuraEnabled(cacheable=true)
    public static String getNonBlankFields(String recordId) {
        if (String.isEmpty(recordId)) {
            return 'Record Id is required.';
        }

        Id objectId = Id.valueOf(recordId);
        String objectName = objectId.getSObjectType().getDescribe().getName();

        List<String> fieldNames = getFieldNames(objectName);

        String query = 'SELECT ' + String.join(fieldNames, ',');
        for (String relationship : childRelationships) {
            String childObjectName = getChildObjectName(relationship, objectName);
            if(childObjectName != null){
                List<String> childFieldNames = getFieldNames(childObjectName);
                query += ', (SELECT ' + String.join(childFieldNames, ',') + ' FROM ' + relationship + ')';
            }
        }
        query += ' FROM ' + objectName + ' WHERE Id = :objectId';

        SObject record = Database.query(query);

        List<String> nonBlankFieldList = getNonBlankFieldList(record, objectName);

        for (String relationship : childRelationships) {
            List<SObject> childRecords = (List<SObject>)record.getSObjects(relationship);
            if (childRecords != null) {
                for (SObject childRecord : childRecords) {
                    String childObjectName = childRecord.getSObjectType().getDescribe().getName();
                    nonBlankFieldList.addAll(getNonBlankFieldList(childRecord, childObjectName));
                }
            }
        }

        String promptPrefix = 'You are a Salesforce assistant assisting the Lifen teams. Lifen is a startup of 160 people in the healthcare sector. Lifen’s clients are healthcare facilities (clinics, hospitals, etc.). Lifen markets SaaS products to these facilities: there are several different products that can be deployed in various scopes (for example, on certain services and not others). You have access to Accounts (customer accounts), Opportunities (sales opportunities), and Deployments (project management object). You are provided with the different fields you can use on these objects, and their meanings. Your role is to provide a summary of the Salesforce Account strictly following this structure:        Paragraph 1 : title : ‘Info on the Account : [Account Name]’ - What is the type of Account - is it a client or not (based on the field ClientLifecycle) and if yes, since when? - what is the tiering of the account? - what are the software used of this account (you can use the following fields: DPI2__c, SGL2__c, RIS2__c, GAM2__c, EAI2__c and display the info as a list) Paragraph 2 : title ‘Info on related Opportunities’ - How many opportunities are related to this account? - one line for each opportunity with : opportunity name, stage, associated revenue (Total_MRR__c), revenue play (Revenue_Play__c) Paragraph 3 : title ‘Info on the Deployments’ - How many Deployments are linked to the Account? - one line per deployment with : deployment name, the scopes and frameworks deployed, the deployment status, the kick off date and the end date of the deployment, the installation type. You will not provide any information other than what is requested. If you cannot find information, you should respond that you do not know how to answer. I need you to do some formatting on the output: your response should only be formatted into html tags. All the titles should be <b> tags and all the associated text should be <p> tags. Do not use `/n`line breaks in your response. -';
        String prompt = promptPrefix + String.join(nonBlankFieldList, ', '); 
        return ChatGPTService.generateResponse(prompt);
    }

    /**
     * Returns the list of field names for the given object.
     */
    private static List<String> getFieldNames(String objectName) {
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();

        for (String fieldName : fieldMap.keySet()) {
            if (!fieldMap.get(fieldName).getDescribe().isCalculated() && !excludedFields.contains(fieldName.toUpperCase())) {
                fieldNames.add(fieldName);
            }
        }

        return fieldNames;
    }

    /**
     * Returns the child object name for the given relationship name.
     */
    private static String getChildObjectName(String relationshipName, String parentObjectName) {
        Schema.SObjectType parentObjectType = Schema.getGlobalDescribe().get(parentObjectName);
        Schema.ChildRelationship childRelation = null;
        for (Schema.ChildRelationship relation : parentObjectType.getDescribe().getChildRelationships()) {
            if (relation.getRelationshipName() == relationshipName) {
                childRelation = relation;
                break;
            }
        }
        if (childRelation != null) {
            return childRelation.getChildSObject().getDescribe().getName();
        } else {
            return null;
        }
    }

    /**
     * Returns the list of non-blank field names and values for the given record.
     */
    private static List<String> getNonBlankFieldList(SObject record, String objectName) {
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        List<String> nonBlankFieldList = new List<String>();
    
        for (String fieldName : fieldMap.keySet()) {
            try {
                Object fieldValue = record.get(fieldName);
                if (fieldValue != null && String.valueOf(fieldValue).trim() != '') {
                    String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                    nonBlankFieldList.add(fieldLabel + ': ' + fieldValue);
                }
            } catch (System.SObjectException e) {
                // Field not available in the result, skip and proceed
            }
        }
    
        return nonBlankFieldList;
    }
    
}

 