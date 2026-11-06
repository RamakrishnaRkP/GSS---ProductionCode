pageextension 60150 "GSSPosted Return Receipts" extends "Posted Return Receipts"
{
    layout
    {
        addafter("No.")
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
