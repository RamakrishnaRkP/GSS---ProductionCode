pageextension 60132 "GSSPurchase Credit Memos" extends "Purchase Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.Setfilter("Purchaser Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var UserSetup: Record "User Setup";
}
