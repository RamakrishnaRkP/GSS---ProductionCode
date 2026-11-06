page 60109 OppListAPI
{
    PageType = API;
    Caption = 'Opportunities';
    APIPublisher = 'GSS';
    APIGroup = 'Opportunity';
    APIVersion = 'v1.0';
    EntityName = 'Opportunity';
    EntitySetName = 'Opportunity';
    SourceTable = Opportunity;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Opportunity_No; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Salesperson_Code; Rec."Salesperson Code")
                {
                }
                field(Campaign_No; Rec."Campaign No.")
                {
                }
                field(Contact_No; Rec."Contact No.")
                {
                }
                field(Contact_Company_No; Rec."Contact Company No.")
                {
                }
                field(Sales_Cycle_Code; Rec."Sales Cycle Code")
                {
                }
                field(Sales_Document_No; Rec."Sales Document No.")
                {
                }
                field(Creation_Date; Rec."Creation Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field(Closed; Rec.Closed)
                {
                }
                field(Date_Closed; Rec."Date Closed")
                {
                }
                field(No_Series; Rec."No. Series")
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field(Current_Sales_Cycle_Stage; Rec."Current Sales Cycle Stage")
                {
                }
                field(Estimated_Value_LCY; Rec."Estimated Value (LCY)")
                {
                }
                field(Probability_Percent; Rec."Probability %")
                {
                }
                field(Calcd_Current_Value_LCY; Rec."Calcd. Current Value (LCY)")
                {
                }
                field(Chances_of_Success_Percent; Rec."Chances of Success %")
                {
                }
                field(Completed_Percent; Rec."Completed %")
                {
                }
                field(Contact_Name; Rec."Contact Name")
                {
                }
                field(Contact_Company_Name; Rec."Contact Company Name")
                {
                }
                field(Salesperson_Name; Rec."Salesperson Name")
                {
                }
                field(Campaign_Description; Rec."Campaign Description")
                {
                }
                field(Segment_No; Rec."Segment No.")
                {
                }
                field(Estimated_Closing_Date; Rec."Estimated Closing Date")
                {
                }
                field(Sales_Document_Type; Rec."Sales Document Type")
                {
                }
                field(No_of_Interactions; Rec."No. of Interactions")
                {
                }
                field(Wizard_Step; Rec."Wizard Step")
                {
                }
                field(Activate_First_Stage; Rec."Activate First Stage")
                {
                }
                field(Segment_Description; Rec."Segment Description")
                {
                }
                field(WizardEstimatedValueLCY; Rec."Wizard Estimated Value (LCY)")
                {
                }
                field(WizardChancesofSuccess_Percent; Rec."Wizard Chances of Success %")
                {
                }
                field(WizardEstimatedClosingDate; Rec."Wizard Estimated Closing Date")
                {
                }
                field(WizardContactName; Rec."Wizard Contact Name")
                {
                }
                field(WizardCampaignDescription; Rec."Wizard Campaign Description")
                {
                }
                field(Customer_Type; Rec."Customer Type")
                {
                }
                field(Email_Triggered; Rec."Email Triggered")
                {
                }
                field(Global_Dimension1_Code; Rec."Global Dimension 1 Code")
                {
                }
                field(PreSale_Required; Rec."Pre-Sale Required")
                {
                }
                field(PreSales_Person; Rec."Pre-Sales Person")
                {
                }
                field(PreSalesPerson_Name; Rec."Pre-SalesPerson Name")
                {
                }
                field(Company; CompanyName())
                {
                }
            }
        }
    }
}
