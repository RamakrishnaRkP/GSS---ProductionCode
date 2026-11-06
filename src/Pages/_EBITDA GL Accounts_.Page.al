page 60105 "EBITDA GL Accounts"
{
    Caption = 'EBITDA G/L Accounts';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "GSS EBITDA GL Accounts";

    layout
    {
        area(Content)
        {
            repeater("G/L Accounts")
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
