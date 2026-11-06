pageextension 60122 GSSGeneralLedgerRegister extends "G/L Registers"
{
    actions
    {
        addafter("G/L Register")
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
                    VPV: Report "GSSVendor Payment VoucherV2";
                    GLEntry: Record "g/l entry";
                begin
                    clear(GLEntry);
                    GLEntry.reset;
                    GLEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
                    vpv.SetTableView(GLEntry);
                    VPV.RunModal();
                end;
            }
        }
    }
    var myInt: Integer;
}
