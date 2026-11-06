pageextension 60142 "GSSSales Credit Memos" extends "Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var UserSetup: Record "User Setup";
}
