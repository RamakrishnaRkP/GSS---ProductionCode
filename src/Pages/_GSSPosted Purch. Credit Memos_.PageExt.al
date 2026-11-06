pageextension 60139 "GSSPosted Purch. Credit Memos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
                Visible = false;
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
