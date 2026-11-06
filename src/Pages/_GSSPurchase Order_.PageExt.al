pageextension 60121 "GSSPurchase Order" extends "Purchase Order"
{
    layout
    {
        addbefore("VAT Bus. Posting Group")
        {
            field("GSSGen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("GSSVendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Vendor Invoice No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Invoice No.")
        {
            field("GSSCurrency To Print"; Rec."GSSCurrency To Print")
            {
                ApplicationArea = All;
            }
            field("GSSCurrency Exchange Rate"; Rec."GSSCurrency Exchange Rate")
            {
                ApplicationArea = All;
            }
        }
        ////Rk
        addafter("Buy-from Vendor Name")
        {
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Prepayment Test &Report")
        {
            action(UpdatePO)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurLineRec: Record "Purchase Line";
                begin
                    PurLineRec.SetRange("Document Type", Rec."Document Type");
                    PurLineRec.SetRange("Document No.", Rec."No.");
                    if PurLineRec.FindSet() then
                        repeat
                            PurLineRec.Validate("Quantity Invoiced", PurLineRec."Quantity Received");
                            PurLineRec."Qty. Rcd. Not Invoiced" := 0;
                            PurLineRec."Qty. Rcd. Not Invoiced (Base)" := 0;
                            PurLineRec."Amt. Rcd. Not Invoiced" := 0;
                            PurLineRec."Amt. Rcd. Not Invoiced (LCY)" := 0;
                            PurLineRec."A. Rcd. Not Inv. Ex. VAT (LCY)" := 0;
                            PurLineRec.Modify();
                        until PurLineRec.Next() = 0;
                    Rec."Amt. Rcd. Not Invoiced (LCY)" := 0;
                    Rec."A. Rcd. Not Inv. Ex. VAT (LCY)" := 0;
                    Rec.Modify();
                    CurrPage.Update(false);
                end;
            }
        }
        modify(Reopen)
        {
            trigger OnAfterAction()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", Rec."No.");
                if PurchaseLine.FindSet() then
                    repeat
                        PurchaseLine.Reopened := true;
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;
            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec."Document Type" = Rec."Document Type"::Order then begin
                    if Rec."PO Type" = Rec."PO Type"::" " then
                        Error('PO Type must have a value in Purchase Header: Document Type=%1, No.=%2. It cannot be zero or empty.', Rec."Document Type", Rec."No.");
                    //Rec.testfield(Rec."PO Type");
                end;
            end;
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PODialog: Page "PO Type Dialog";
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if PODialog.RunModal() = Action::OK then
                Rec."PO Type" := PODialog.GetPOType()
            else
                Error('Please select a PO Type.');
        end;
    end;
}
