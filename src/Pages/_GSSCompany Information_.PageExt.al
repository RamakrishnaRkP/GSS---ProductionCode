pageextension 60125 "GSSCompany Information" extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("GSSCompany Shortcode"; Rec."GSSCompany Shortcode")
            {
                ApplicationArea = All;
            }
        }
        addlast(Payments)
        {
            field("Account No. (AED)"; Rec."Account No. (AED)")
            {
                ApplicationArea = All;
            }
            field("Account No. (USD)"; Rec."Account No. (USD)")
            {
                ApplicationArea = All;
            }
            field("IBAN (AED)"; Rec."IBAN (AED)")
            {
                ApplicationArea = All;
            }
            field("IBAN (USD)"; Rec."IBAN (USD)")
            {
                ApplicationArea = All;
            }
            field("Bank Address"; Rec."Bank Address")
            {
                ApplicationArea = All;
            }
        }
    }
}
