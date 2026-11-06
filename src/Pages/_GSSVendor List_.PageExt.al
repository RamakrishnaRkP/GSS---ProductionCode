pageextension 60120 "GSSVendor List" extends "Vendor List"
{
    actions
    {
        addlast("Financial Management")
        {
            action(GSSVendorAgingSummary)
            {
                ApplicationArea = All;
                Caption = 'Vendor Aging - Summary';
                Image = Report2;

                trigger OnAction()
                var
                    VendorAgingSummary: Report "GSSVendor Aging - Summary";
                begin
                    VendorAgingSummary.RunModal();
                end;
            }
            action(GSSVendorAgingDetailed)
            {
                ApplicationArea = All;
                Caption = 'Vendor Aging - Detailed';
                Image = Report2;

                trigger OnAction()
                var
                    VendorAgingDetailed: Report "GSSVendor Aging - Detailed";
                begin
                    VendorAgingDetailed.RunModal();
                end;
            }
        }
    }
}
