pageextension 60100 "GSSSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Archive Return Orders")
        {
            field("GSSArch. Sales Doc. On Insert"; Rec."GSSArch. Sales Doc. On Insert")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if you want to archive sales documents when they are created.';
            }
            field("GSSArch. Sales Doc. On Release"; Rec."GSSArch. Sales Doc. On Release")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if you want to archive sales documents when they are released.';
            }
        }
        addlast(General)
        {
            field("GSSSkip Delete After Post"; Rec."GSSSkip Delete After Post")
            {
                ToolTip = 'Specifies if you want to skip sales document deletion after they are posted.';
                ApplicationArea = All;
            }
            field("GSSSkip Delete After SQConvert"; Rec."GSSSkip Delete After SQConvert")
            {
                ToolTip = 'Specifies if you want to skip sales document deletion after they are converted to order.';
                ApplicationArea = All;
            }
            field(GSSInvoicingReportEmail; Rec.GSSInvoicingReportEmail)
            {
                ApplicationArea = All;
            }
        }
    }
}
