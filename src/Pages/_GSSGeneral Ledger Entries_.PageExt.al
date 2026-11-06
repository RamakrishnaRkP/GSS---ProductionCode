pageextension 60104 "GSSGeneral Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSHR Integration Entry"; Rec."GSSHR Integration Entry")
            {
                ApplicationArea = All;
            }
            field(Comment; Rec.Comment)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            field(SystemCreatedDate; DT2Date(Rec.SystemCreatedAt))
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetupRec: Record "User Setup";
    begin
        if UserSetupRec.Get(UserId)then;
        if UserSetupRec."Salespers./Purch. Code" <> '' then Rec.SetFilter("Shortcut Dimension 3 Code", UserSetupRec."Salespers./Purch. Code");
    end;
}
