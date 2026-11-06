pageextension 60115 "GSSJob Task Lines Subform" extends "Job Task Lines Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(GSSStatus; Rec.GSSStatus)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter("End Date")
        {
            field("GSSRenewal Date"; Rec."GSSRenewal Date")
            {
                ApplicationArea = All;
            }
        }
        ////Rk

        modify("Job Posting Group")
        {
            Visible = true;

        }
    }
    /* actions
        {
            addafter("F&unctions")
            {
                action(TestRecordID)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        JobTaskRec: Record "Job Task";
                    begin
                        If JobTaskRec.GetBySystemId('{15272b27-67b3-ed11-9a88-6045bd6b41d0}') then
                            Message('Found');
                    end;
                }
            }
        } */

    trigger OnAfterGetRecord()
    begin
        Rec."GSSGross Margin" :=
            Rec."Contract (Total Price)" - Rec."Schedule (Total Cost)";
        if Rec."Contract (Total Price)" <> 0 then
            Rec."GSSGross Margin %" :=
                Round(
                    (Rec."GSSGross Margin" / Rec."Contract (Total Price)") * 100,
                    0.1
                )
        else
            Rec."GSSGross Margin %" := 0;
    end;
}
