pageextension 60148 "GSSPosted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("GSSJob No."; rec."GSSJob No.")
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
