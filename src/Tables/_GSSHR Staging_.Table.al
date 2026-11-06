table 60100 "GSSHR Staging"
{
    Caption = 'GSSHR Staging ';
    DataClassification = ToBeClassified;

    fields
    {
        field(11; LINE_NUM; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(21; JOURNAL_NAME; Text[50])
        {
            Caption = 'Journal Name';
            DataClassification = CustomerContent;
        }
        field(31; LEDGER_NAME; Text[50])
        {
            Caption = 'Ledger Name';
            DataClassification = CustomerContent;
        }
        field(41; PERIOD_DATE; Text[50])
        {
            Caption = 'Period Date';
            DataClassification = CustomerContent;
        }
        field(51; GL_CODE; Code[20])
        {
            Caption = 'GL Code';
            DataClassification = CustomerContent;
        }
        field(61; AMOUNT_DR; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(71; AMOUNT_CR; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(81; DESCRIPTION; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(91; PROCESS_FLAG; Text[1])
        {
            Caption = 'Process';
            DataClassification = CustomerContent;
        }
        field(101; ERR_MSG; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(121; BATCH_NUMBER; Text[50])
        {
            Caption = 'Batch Number';
            DataClassification = CustomerContent;
        }
        field(131; BATCH_DATE; Date)
        {
            Caption = 'Batch Date';
            DataClassification = CustomerContent;
        }
        field(141; HR_USER; Text[50])
        {
            Caption = 'HR User';
            DataClassification = CustomerContent;
        }
        field(151; CURRENCY; Text[50])
        {
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(161; PROCESS_DATE; Date)
        {
            Caption = 'Process Date';
            DataClassification = CustomerContent;
        }
        field(171; PROCESS_TIME; Time)
        {
            Caption = 'Process Time';
            DataClassification = CustomerContent;
        }
        field(181; NAV_PROCESSED; Boolean)
        {
            Caption = 'Nav Processed';
            DataClassification = CustomerContent;
        }
        field(182; NAV_PROCESSED_DATE; Date)
        {
            Caption = 'Nav Processed Date';
            DataClassification = CustomerContent;
        }
        field(183; NAV_PROCESSED_TIME; Time)
        {
            Caption = 'Nav Processed Time';
            DataClassification = CustomerContent;
        }
        field(184; NAV_ERROR; Boolean)
        {
            Caption = 'Nav Error';
            DataClassification = CustomerContent;
        }
        field(185; NAV_ERR_MESSAGE; Text[250])
        {
            Caption = 'Nav Error Message';
            DataClassification = CustomerContent;
        }
        field(186; NAV_SKIPPED; Boolean)
        {
            Caption = 'Nav Skipped';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; LINE_NUM)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
        LastLineNo: Integer;
        HRStagingEntries: Record "GSSHR Staging";
    begin
        if HRStagingEntries.FindLast()then LastLineNo:=HRStagingEntries.LINE_NUM;
        LINE_NUM:=LastLineNo + 10000;
    end;
}
