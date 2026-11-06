table 60102 "GL Recovery Staging"
{
    Caption = 'G/L Recovery Staging';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(10; "Orig. Entry No."; Integer)
        {
            Caption = 'Original Entry No.';
        // Reference/reconciliation only. NOT reused - G/L Entry."Entry No." is AutoIncrement, system-assigned.
        }
        field(11; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        // CRITICAL: must match the original export exactly - this is what keeps VAT Entry, Detailed
        // Cust./Vendor Ledger Entry, Job Ledger Entry, Value Entry etc. correctly linked to this row.
        }
        field(12; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        // CRITICAL: copy the original numeric ID directly. Since Dimension Set Entry data is intact,
        // do NOT rebuild this from Global Dimension text codes - just reuse the original ID as-is.
        }
        field(20; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
        }
        field(21; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Document Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(23; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(24; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(25; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(26; "Debit Amount (LCY)"; Decimal)
        {
            Caption = 'Debit Amount (LCY)';
            DecimalPlaces = 2: 2;
        }
        field(27; "Credit Amount (LCY)"; Decimal)
        {
            Caption = 'Credit Amount (LCY)';
            DecimalPlaces = 2: 2;
        }
        field(28; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DecimalPlaces = 2: 2;
        }
        field(29; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(30; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
        }
        field(31; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(32; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(33; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(34; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(35; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(36; "Prior-Year Entry"; Boolean)
        {
            Caption = 'Prior-Year Entry';
        }
        field(37; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(40; "Gen. Posting Type";Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
        }
        field(41; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        field(42; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(43; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(44; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
        }
        field(45; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DecimalPlaces = 2: 2;
        }
        field(46; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
        }
        field(47; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(48; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
        }
        field(50; "Bal. Account Type";Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(51; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
        }
        field(60; "Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
        }
        field(61; "Source Currency Amount"; Decimal)
        {
            Caption = 'Source Currency Amount';
            DecimalPlaces = 2: 2;
        }
        field(62; "Additional-Currency Amount"; Decimal)
        {
            Caption = 'Additional-Currency Amount';
            DecimalPlaces = 2: 2;
        }
        field(63; "Add.-Currency Debit Amount"; Decimal)
        {
            Caption = 'Add.-Currency Debit Amount';
            DecimalPlaces = 2: 2;
        }
        field(64; "Add.-Currency Credit Amount"; Decimal)
        {
            Caption = 'Add.-Currency Credit Amount';
            DecimalPlaces = 2: 2;
        }
        field(70; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(71; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(72; "Job No."; Code[20])
        {
            Caption = 'Project No.';
        }
        // --- Processing status ---
        field(90; "Row Inserted"; Boolean)
        {
            Caption = 'Row Inserted';
            Editable = false;
        }
        field(91; "New Entry No."; Integer)
        {
            Caption = 'New Entry No. (after insert)';
            Editable = false;
        }
        field(92; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
        key(Grouping; "Transaction No.", "Orig. Entry No.")
        {
        }
    }
}
