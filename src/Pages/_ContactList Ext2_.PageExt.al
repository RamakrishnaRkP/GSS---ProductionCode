pageextension 60186 "ContactList Ext2" extends "Contact List"
{
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.SetFilter("Salesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var UserSetup: Record "User Setup";
}
