pageextension 60135 "GSSPurchase Order Archives" extends "Purchase Order Archives"
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
        if UserSetup."SalesPerson Filter" <> '' then Rec.Setfilter("Purchaser Code", UserSetup."SalesPerson Filter");
    end;
    var UserSetup: Record "User Setup";
}
