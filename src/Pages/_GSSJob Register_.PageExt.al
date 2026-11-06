pageextension 60117 "GSSJob Register" extends "Job Registers"
{
    layout
    {
        addafter("No.")
        {
            field("GSS Document No."; "GSS Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Job Ledger")
        {
            action(GSSJobDeliveryNote)
            {
                Caption = 'Job Delivery Note';
                Image = "Report2";
                Promoted = true;
                PromotedCategory = "Process";
                ApplicationArea = All;

                trigger OnAction()
                var
                    JDN: Report "GSSJob Delivery Note V2";
                    JobRegister: Record "Job Register";
                begin
                    CurrPage.SetSelectionFilter(JobRegister);
                    JDN.SetTableView(JobRegister);
                    JDN.RunModal();
                end;
            }
        }
    }
}
