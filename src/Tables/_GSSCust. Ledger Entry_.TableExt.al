tableextension 60101 "GSSCust. Ledger Entry" extends "Cust. Ledger Entry"
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


        ///Rk 281026

        field(60121; "Job No."; code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
    }
}
