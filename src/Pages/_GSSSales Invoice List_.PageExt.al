pageextension 60141 "GSSSales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field(GSSVATAmount;(Rec."Amount Including VAT" - Rec.Amount))
            {
                Caption = 'VAT Amount';
                ApplicationArea = All;
            }
            field("GSSAmount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
            }
            field("GSSPayment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("GSSPayment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("GSSJob No."; Rec."GSSJob No.")
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
        if UserSetupRec."Salespers./Purch. Code" <> '' then begin
            Rec.FilterGroup(100);
            Rec.SetFilter("Salesperson Code", UserSetupRec."Salespers./Purch. Code");
            Rec.FilterGroup(0);
        end;
    end;
}
