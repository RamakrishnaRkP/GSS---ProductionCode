page 60110 OppEntryListAPI
{
    PageType = API;
    Caption = 'OpprtunityEntries';
    APIPublisher = 'GSS';
    APIGroup = 'Opportunity';
    APIVersion = 'v1.0';
    EntityName = 'Opportunity_Entry';
    EntitySetName = 'Opportunity_Entry';
    SourceTable = "Opportunity Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Opportunity_No; Rec."Opportunity No.")
                {
                }
                field(Opportunity_Entry_No; Rec."Entry No.")
                {
                }
                field(Sales_Cycle_Code; Rec."Sales Cycle Code")
                {
                }
                field(Sales_Cycle_Stage; Rec."Sales Cycle Stage")
                {
                }
                field(Contact_No; Rec."Contact No.")
                {
                }
                field(Contact_Company_No; Rec."Contact Company No.")
                {
                }
                field(Salesperson_Code; Rec."Salesperson Code")
                {
                }
                field(Campaign_No; Rec."Campaign No.")
                {
                }
                field(Date_of_Change; Rec."Date of Change")
                {
                }
                field(Active; Rec.Active)
                {
                }
                field(Date_Closed; Rec."Date Closed")
                {
                }
                field(Days_Open; Rec."Days Open")
                {
                }
                field(Action_Taken; Rec."Action Taken")
                {
                }
                field(Estimated_Value_LCY; Rec."Estimated Value (LCY)")
                {
                }
                field(Calcd_Current_Value_LCY; Rec."Calcd. Current Value (LCY)")
                {
                }
                field(Completed; Rec."Completed %")
                {
                }
                field(Chances_of_Success_Percent; Rec."Chances of Success %")
                {
                }
                field(Probability_Percent; Rec."Probability %")
                {
                }
                field(Close_Opportunity_Code; Rec."Close Opportunity Code")
                {
                }
                field(Previous_Sales_Cycle_Stage; Rec."Previous Sales Cycle Stage")
                {
                }
                field(Estimated_Close_Date; Rec."Estimated Close Date")
                {
                }
                field(Cancel_Old_ToDo; Rec."Cancel Old To Do")
                {
                }
                field(Action_Type; Rec."Action Type")
                {
                }
                field(Sales_Cycle_Stage_Description; Rec."Sales Cycle Stage Description")
                {
                }
                field(Company; CompanyName())
                {
                }
            }
        }
    }
}
