pageextension 60102 "GSSVendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSHR Integration Entry"; Rec."GSSHR Integration Entry")
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
