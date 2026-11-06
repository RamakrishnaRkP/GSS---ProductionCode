pageextension 60158 "GSSAccountant Activities" extends "Accountant Activities"
{
    layout
    {
        addbefore(Payments)
        {
            cuegroup(Invoicing)
            {
                Caption = 'Invoicing';

                //Visible = SetupIsComplete;
                field("Upcoming Invoices"; Rec."GSSUpcoming Invoices")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the number of upcoming invoices that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Invoices Due - Not Created"; Rec."GSSInvoices Due - Not Created")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the number of invoices that are due but not yet created that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }
                actions
                {
                    action("Job Create Sales Invoice")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Create Sales Invoice';
                        RunObject = Report "Job Create Sales Invoice";
                        ToolTip = 'Create an invoice for a job or for one or more job tasks for a customer when either the work to be invoiced is complete or the date for invoicing based on an invoicing schedule has been reached.';
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("GSSDate Filter", '>=%1', WorkDate);
        Rec.SetFilter("GSSDate Filter2", '<%1&<>%2', WorkDate, 0D);
    end;
}
