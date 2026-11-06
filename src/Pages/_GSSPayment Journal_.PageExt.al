pageextension 60109 "GSSPayment Journal" extends "Payment Journal"
{
    layout
    {
        addafter(Description)
        {
        }
    }
    actions
    {
        addafter("Test Report")
        {
            action(GSSVendorPaymentVoucherV2)
            {
                Caption = 'Vendor Payment Voucher';
                Image = "Report2";
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = All;

                trigger OnAction()
                var
                    VPV: Report "Payment Voucher Preview";
                    GenJnlLineRec: Record "Gen. Journal Line";
                begin
                    Clear(GenJnlLineRec);
                    GenJnlLineRec.reset;
                    GenJnlLineRec.SetRange("Document No.", Rec."Document No.");
                    vpv.SetTableView(GenJnlLineRec);
                    VPV.RunModal();
                end;
            }
        }
    }
}
