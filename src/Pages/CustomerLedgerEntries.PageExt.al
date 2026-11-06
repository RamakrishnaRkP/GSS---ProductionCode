#pragma implicitwith disable
pageextension 60101 "GSSCustomer Ledger Entries" extends "Customer Ledger Entries"
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

        ///Rk281026
        addafter("Document No.")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.SetFilter("Salesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;

    trigger OnAfterGetRecord()
    var
        Events: Codeunit Events;
    begin
        Events.InsertjobtoCustomerled(Rec)
    end;

    var
        UserSetup: Record "User Setup";
}

#pragma implicitwith restore
