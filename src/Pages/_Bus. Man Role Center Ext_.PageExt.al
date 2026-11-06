pageextension 60199 "Bus. Man Role Center Ext" extends "Business Manager Role Center"
{
    layout
    {
        modify(Control9)
        {
            Visible = false;
        }
        modify("User Tasks Activities")
        {
            Visible = false;
        }
        addbefore(Emails)
        {
            part(PendingTaskCues; "Pending Task Cues")
            {
                ApplicationArea = All;
            }
            part(Jobs; "Job Cues")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Control96)
        {
        /* part(Control98Ext; "Power BI Report Spinner Part")
            {
                Caption = 'Power BI Report';
                AccessByPermission = TableData "Power BI User Configuration" = I;
                ApplicationArea = Basic, Suite;
            } */
        }
    }
}
