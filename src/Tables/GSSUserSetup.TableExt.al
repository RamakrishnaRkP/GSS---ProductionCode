tableextension 60129 GSSUserSetup extends "User Setup"
{
    fields
    {
        field(50000; "Block Delivery Access"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60100; "GSSAllow Job Jnl Update"; Boolean)
        {
            Caption = 'Allow Job Jnl. Update';
            DataClassification = CustomerContent;
        }
        field(60101; "GSSDepartment Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(60102; "SalesPerson Filter"; Text[100])
        {
            Caption = 'SalesPerson Filter';
            DataClassification = CustomerContent;
        }
        field(60103; "Delete Access"; Boolean)
        {
            Caption = 'Delete Access';
            DataClassification = CustomerContent;
        }
        field(60104; "Allow Reopening"; Boolean)
        {
            Caption = 'Allow Reopening';
            DataClassification = CustomerContent;
        }
        field(60105; "Admin User"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Admin User';
        }
        field(60106; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1), Blocked=CONST(false));
        }
        field(60107; "Document Admin"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60108; "Allow Job Exception"; Boolean)
        {
            Caption = 'Allow Job Exception';
            DataClassification = CustomerContent;
        }
        field(60109; "Finance User"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Finance User';
        }
    }
}
