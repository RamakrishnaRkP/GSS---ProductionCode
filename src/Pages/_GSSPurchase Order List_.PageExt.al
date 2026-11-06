pageextension 60130 "GSSPurchase Order List" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
            field("GSSCurrency To Print"; Rec."GSSCurrency To Print")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("GSSCurrency Exchange Rate"; Rec."GSSCurrency Exchange Rate")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)")
            {
                ApplicationArea = All;
                Caption = 'Rcvd. not Invoiced (LCY)';
            }
            field("Outstanding Amount"; Rec."Outstanding Amount")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Reopen)
        {
            trigger OnAfterAction()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", Rec."No.");
                if PurchaseLine.FindSet()then repeat PurchaseLine.Reopened:=true;
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;
            end;
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
