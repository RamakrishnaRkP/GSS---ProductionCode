report 60115 "GSS Delivery Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSS Delivery Note.rdl';
    Caption = 'Delivery Note';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "Sell-to Customer No.", "No.", "Posting Date";

            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddrese; CompInfo.Address + ' Tel :' + '  ' + CompInfo."Phone No." + ' Fax : ' + CompInfo."Fax No.")
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
            column(DeliveryDate; FORMAT("Sales Shipment Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
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

                /* 
                column(SlNo;"Sales Shipment Line"."Group Nos")
                {
                }
                */
                column(PartNo; "Sales Shipment Line"."No.")
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
                /* itos comment
                column(ManfItemNo_SalesShipmentLine;"Sales Shipment Line"."Manf. Item No.")
                {
                }
                column(ManfItemDesc_SalesShipmentLine;"Sales Shipment Line"."Manf. Item Desc.")
                {
                }
                */
                trigger OnAfterGetRecord();
                begin
                    if "Sales Shipment Line".Quantity = 0 then DoNotShow:=true
                    else
                        DoNotShow:=false;
                    SlNo:=SlNo + 1;
                    Item.RESET;
                    Item.SETRANGE(Item."No.", "Sales Shipment Line"."No.");
                    if Item.FINDFIRST then SerielNo:=Item."Serial Nos.";
                    if Type = Type::Item then /*BEGIN
                          IF ItemRec.GET("No.") THEN
                            Descr:=ItemRec.Description+ItemRec."Description 2"+ItemRec."Description 3"
                        END ELSE BEGIN*/
                        Descr:=Description;
                    //END;
                    SerialNo:='';
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Document No.", "Sales Shipment Line"."Document No.");
                    recILE.SETRANGE(recILE."Item No.", "Sales Shipment Line"."No.");
                    recILE.SETFILTER(recILE."Serial No.", '<>%1', '');
                    if recILE.FINDFIRST then repeat SerialNo:=SerialNo + recILE."Serial No." + ', ';
                        until recILE.NEXT = 0;
                    if "Sales Shipment Line".Quantity = 0 then CurrReport.SKIP;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Sales Shipment Header"."Sell-to Customer No.");
                if Cust.FINDFIRST then begin
                    Addresse:=Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City;
                    Phone:=Cust."Phone No.";
                end;
                RecContact.RESET;
                RecContact.SETRANGE(RecContact."No.", "Sales Shipment Header"."Sell-to Contact No.");
                if RecContact.FINDFIRST then ContactPerson:=RecContact.Name;
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
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        CompanyShortcode:=CompInfo."GSSCompany Shortcode";
    end;
    var CompInfo: Record "Company Information";
    SlNo: Integer;
    Item: Record Item;
    SerielNo: Code[50];
    Cust: Record Customer;
    CustContact: Code[50];
    ItemRec: Record Item;
    Descr: Text;
    Addresse: Text[150];
    RecContact: Record Contact;
    ContactPerson: Text[100];
    Phone: Code[50];
    recILE: Record "Item Ledger Entry";
    SerialNo: Text;
    DoNotShow: Boolean;
    CompanyShortcode: Text;
}
