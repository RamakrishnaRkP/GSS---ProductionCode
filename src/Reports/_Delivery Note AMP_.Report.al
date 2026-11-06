report 60133 "Delivery Note AMP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSS Delivery Note-Amp.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "Sell-to Customer No.", "No.", "Posting Date";

            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddrese; CompInfo.Address + ' Tel :' + '  ' + CompInfo."Phone No.")
            {
            }
            column(CompInfoTRN; CompInfo."VAT Registration No.")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            column(CompPhone; CompInfo."Phone No.")
            {
            }
            column(CompFax; CompInfo."Fax No.")
            {
            }
            column(DeliveryNo; "Sales Shipment Header"."No.")
            {
            }
            column(DeliveryDate; FORMAT("Sales Shipment Header"."Posting Date", 0, '<Day,2>-<Month,2>-<Year4>'))
            {
            }
            column(SalesOrderNo; "Sales Shipment Header"."Order No.")
            {
            }
            column(CustomerReference; "Sales Shipment Header"."External Document No.")
            {
            }
            column(Customername; "Sales Shipment Header"."Sell-to Customer Name")
            {
            }
            column(CustomerAddresse; Addresse)
            {
            }
            column(CustomerContact; Phone)
            {
            }
            column(ContactPerson; ContactPerson)
            {
            }
            column(CompanyShortcode; CompanyShortcode)
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")ORDER(Ascending);

                column(SlNo; SlNo) //"Group Nos")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
                column(PartNo; ItemCode) //ItemRec."Catalogue Code")
                {
                }
                column(Description; Descr)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(DoNotShow; DoNotShow)
                {
                }
                column(UOM; "Unit of Measure Code")
                {
                }
                column(LotNo; LotNo)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No."=FIELD("Document No."), "Item No."=field("No."), "Document Line No."=field("Line No.");
                    DataItemLinkReference = "Sales Shipment Line";

                    column(Document_No_; "Document No.")
                    {
                    }
                    column(LotNo_ILE; ILELOT)
                    {
                    }
                    column(Lot_Qty; ABS(Quantity))
                    {
                    }
                    trigger OnPreDataItem()
                    var
                    begin
                    end;
                    trigger OnAfterGetRecord()
                    begin
                        Clear(ILELOT);
                        if "Item Ledger Entry"."Lot No." = '' then ILELOT:="Item Ledger Entry"."Serial No."
                        else
                            ILELOT:="Item Ledger Entry"."Lot No.";
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(LotNo);
                    IF "Sales Shipment Line".Quantity = 0 THEN DoNotShow:=TRUE
                    ELSE
                    begin
                        DoNotShow:=FALSE;
                        SlNo:=SlNo + 1;
                    end;
                    //SlNo := SlNo + 1;
                    Item.RESET;
                    Item.SETRANGE(Item."No.", "Sales Shipment Line"."No.");
                    IF Item.FINDFIRST THEN SerielNo:=Item."Serial Nos.";
                    //TS-23-12-21-
                    CLEAR(ItemRec);
                    //TS-23-12-21+SerialNo
                    IF Type = Type::Item THEN BEGIN
                        IF ItemRec.GET("No.")THEN BEGIN
                            Descr:=ItemRec.Description + ItemRec."Description 2"; // + ItemRec."Long Description";
                            /*  IF ItemRec."Catalogue Code" <> '' THEN
                                                                                        ItemCode := ItemRec."Catalogue Code"
                                                                                    ELSE */
                            ItemCode:=ItemRec."No.";
                        END;
                    END
                    ELSE
                    BEGIN
                        ItemCode:="Sales Shipment Line"."No.";
                        Descr:=Description;
                    END;
                    SerialNo:='';
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Document No.", "Sales Shipment Line"."Document No.");
                    recILE.SETRANGE(recILE."Item No.", "Sales Shipment Line"."No.");
                    recILE.SETFILTER(recILE."Serial No.", '<>%1', '');
                    IF recILE.FINDFIRST THEN REPEAT SerialNo:=SerialNo + recILE."Serial No." + ', ';
                        UNTIL recILE.NEXT = 0;
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Document No.", "Sales Shipment Line"."Document No.");
                    recILE.SETRANGE(recILE."Item No.", "Sales Shipment Line"."No.");
                    if recILE.FindFirst()then repeat if LotNo = '' then LotNo:=recILE."Lot No."
                            else
                                LotNo:=LotNo + ',' + recILE."Lot No.";
                        until recILE.Next() = 0;
                    IF "Sales Shipment Line".Quantity = 0 THEN CurrReport.SKIP;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Sales Shipment Header"."Sell-to Customer No.");
                IF Cust.FINDFIRST THEN BEGIN
                    Addresse:=Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City;
                    Phone:=Cust."Phone No.";
                END;
                RecContact.RESET;
                RecContact.SETRANGE(RecContact."No.", "Sales Shipment Header"."Sell-to Contact No.");
                IF RecContact.FINDFIRST THEN ContactPerson:=RecContact.Name;
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        Clear(SlNo);
    // CompanyShortcode := CompInfo."Company Shortcode";
    end;
    var CompInfo: Record 79;
    SlNo: Integer;
    Item: Record 27;
    SerielNo: Code[50];
    Cust: Record 18;
    CustContact: Code[50];
    ItemRec: Record 27;
    Descr: Text;
    Addresse: Text[150];
    RecContact: Record 5050;
    ContactPerson: Text[100];
    Phone: Code[50];
    recILE: Record 32;
    SerialNo: Text;
    DoNotShow: Boolean;
    CompanyShortcode: Text;
    ItemCode: Code[50];
    LotNo: Code[300];
    ILELOT: Code[300];
//SLNo : Integer;
}
