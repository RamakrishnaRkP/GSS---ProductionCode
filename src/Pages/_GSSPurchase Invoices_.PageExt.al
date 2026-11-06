pageextension 60131 "GSSPurchase Invoices" extends "Purchase Invoices"
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
            Rec.Setfilter("Purchaser Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var UserSetup: Record "User Setup";
}
