tableextension 60103 "GSSG/L Entry" extends "G/L Entry"
{
    fields
    {
        field(60100; "GSSHR Integration Entry"; Boolean)
        {
            Caption = 'HR Integration Entry';
            DataClassification = CustomerContent;
        }
        field(60110; "GSSInstrument No."; Code[30])
        {
            Caption = 'Instrument No.';
            DataClassification = CustomerContent;
        }
        field(60120; "GSSInstrument Date"; Date)
        {
            Caption = 'Instrument Date';
            DataClassification = CustomerContent;
        }
    }
}
