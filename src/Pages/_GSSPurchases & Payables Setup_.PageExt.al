pageextension 60111 "GSSPurchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Archive Return Orders")
        {
            field("GSSArch. Purch. Doc. On Insert"; Rec."GSSArch. Purch. Doc. On Insert")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if you want to archive purchase documents when they are created.';
            }
            field("GSSArch. Purch. Doc. OnRelease"; Rec."GSSArch. Purch. Doc. OnRelease")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if you want to archive purchase documents when they are released.';
            }
        }
        addlast(General)
        {
            field("GSSSkip Delete After Post"; Rec."GSSSkip Delete After Post")
            {
                ToolTip = 'Specifies if you want to skip purchase document deletion after they are posted.';
                ApplicationArea = All;
            }
        }
    }
}
