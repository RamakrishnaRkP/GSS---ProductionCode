pageextension 60144 "GSSPosted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("External Document No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("GSSComments Count"; Rec."GSSComments Count")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then Rec.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
    end;
    var UserSetup: Record "User Setup";
}
