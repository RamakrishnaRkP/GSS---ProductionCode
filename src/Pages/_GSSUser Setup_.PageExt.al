pageextension 60157 "GSSUser Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Document Admin"; Rec."Document Admin")
            {
                ApplicationArea = All;
            }
            field("Allow Job Exception"; Rec."Allow Job Exception")
            {
                ApplicationArea = All;
            }
            field("GSSAllow Job Jnl Update"; Rec."GSSAllow Job Jnl Update")
            {
                ApplicationArea = All;
            }
            field("GSSDepartment"; Rec."GSSDepartment Code")
            {
                ApplicationArea = All;
            }
            field("Block Delivery Access"; Rec."Block Delivery Access")
            {
                ApplicationArea = All;
            }
            field("SalesPerson Filter"; Rec."SalesPerson Filter")
            {
                ApplicationArea = All;
            }
            field("Delete Access"; Rec."Delete Access")
            {
                ApplicationArea = All;
            }
            field("Allow Reopening"; Rec."Allow Reopening")
            {
                ApplicationArea = All;
            }
            field("Admin User"; Rec."Admin User")
            {
                ApplicationArea = All;
            }
            field("Finance User"; "Finance User")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
