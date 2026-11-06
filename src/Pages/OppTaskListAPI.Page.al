page 60111 OppTaskListAPI
{
    PageType = API;
    Caption = 'OpprtunityTaskList';
    APIPublisher = 'GSS';
    APIGroup = 'Opportunity';
    APIVersion = 'v1.0';
    EntityName = 'Opportunity_Task';
    EntitySetName = 'Opportunity_Task';
    SourceTable = "To-do";
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
                field(Opportunity_Entry_No; Rec."Opportunity Entry No.")
                {
                }
                field(Task_No; Rec."No.")
                {
                }
                field(Team_Code; Rec."Team Code")
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
                field(Segment_No; Rec."Segment No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field(Description; Rec.Description)
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
                field(Canceled; Rec.Canceled)
                {
                }
                field(Contact_Name; Rec."Contact Name")
                {
                }
                field(Team_Name; Rec."Team Name")
                {
                }
                field(Salesperson_Name; Rec."Salesperson Name")
                {
                }
                field(Campaign_Description; Rec."Campaign Description")
                {
                }
                field(Contact_Company_No; Rec."Contact Company No.")
                {
                }
                field(Contact_Company_Name; Rec."Contact Company Name")
                {
                }
                field(Recurring; Rec.Recurring)
                {
                }
                field(Recurring_Date_Interval; Rec."Recurring Date Interval")
                {
                }
                field(Calc_DueDate_From; Rec."Calc. Due Date From")
                {
                }
                field(Opportunity_Description; Rec."Opportunity Description")
                {
                }
                field(StartTime; Rec."Start Time")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field(AllDay_Event; Rec."All Day Event")
                {
                }
                field(Location; Rec.Location)
                {
                }
                field(Organizer_Todo_No; Rec."Organizer To-do No.")
                {
                }
                field(Interaction_TemplateCode; Rec."Interaction Template Code")
                {
                }
                field(Language_Code; Rec."Language Code")
                {
                }
                field(Attachment_No; Rec."Attachment No.")
                {
                }
                field(Subject; Rec.Subject)
                {
                }
                field(UnitCost_LCY; Rec."Unit Cost (LCY)")
                {
                }
                field(UnitDuration_Min; Rec."Unit Duration (Min.)")
                {
                }
                field(No_of_Attendees; Rec."No. of Attendees")
                {
                }
                field(Attendees_AcceptedNo; Rec."Attendees Accepted No.")
                {
                }
                field(System_Todo_Type; Rec."System To-do Type")
                {
                }
                field(Completed_By; Rec."Completed By")
                {
                }
                field(Ending_Date; Rec."Ending Date")
                {
                }
                field(Ending_Time; Rec."Ending Time")
                {
                }
                field(Team_Todo; Rec."Team To-do")
                {
                }
                field(Send_on_finish; Rec."Send on finish")
                {
                }
                field(Segment_Description; Rec."Segment Description")
                {
                }
                field(Team_Meeting_Organizer; Rec."Team Meeting Organizer")
                {
                }
                field(Activity_Code; Rec."Activity Code")
                {
                }
                field(Due_Date; Rec."Due Date")
                {
                }
                field(Pre_SalesPerson; Rec."Pre-Sales Person")
                {
                }
                field(Pre_SalesPerson_Name; Rec."Pre-SalesPerson Name")
                {
                }
                field(Company; CompanyName())
                {
                }
            }
        }
    }
}
