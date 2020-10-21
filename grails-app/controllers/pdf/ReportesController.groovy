package pdf

import geografia.Canton
import geografia.Provincia
import jxl.WorkbookSettings
import jxl.format.Border
import jxl.format.BorderLineStyle
import jxl.format.Colour
import jxl.write.Label
import jxl.write.WritableCellFormat
import jxl.write.WritableFont
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import monitor.Periodo
import monitor.Semaforo
import org.apache.poi.hssf.usermodel.HSSFClientAnchor
import org.apache.poi.hssf.usermodel.HSSFPatriarch
import org.apache.poi.hssf.usermodel.HSSFSimpleShape
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.ConditionalFormattingRule
import org.apache.poi.ss.usermodel.CreationHelper
import org.apache.poi.ss.usermodel.Drawing
import org.apache.poi.ss.usermodel.SheetConditionalFormatting
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFClientAnchor
import org.apache.poi.xssf.usermodel.XSSFDrawing
import org.apache.poi.xssf.usermodel.XSSFSimpleShape

import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;


class ReportesController {

    def semaforoExcel(){



        //excel
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()

        WritableWorkbook workbook = jxl.Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)


        // fija el ancho de la columna
        sheet.setColumnView(0,5)
        sheet.setColumnView(1,20)
        sheet.setColumnView(2,30)
        sheet.setColumnView(3,15)
        sheet.setColumnView(4,15)
//        sheet.setColumnView(5,15)

        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        times16font.setColour(Colour.WHITE);
        WritableFont times16fontNormal = new WritableFont(WritableFont.TIMES, 11, WritableFont.NO_BOLD, false);
//        WritableCellFormat times16format = new WritableCellFormat(times16font);
        WritableCellFormat times16formatN = new WritableCellFormat(times16fontNormal);

        WritableCellFormat times16format = new WritableCellFormat(times16font);
        times16format.setBackground(Colour.BLUE_GREY);
        times16format.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.GRAY_50);


        WritableCellFormat rojo = new WritableCellFormat(times16fontNormal);
        rojo.setBackground(Colour.DARK_RED);
        WritableCellFormat amarillo = new WritableCellFormat(times16fontNormal);
        amarillo.setBackground(Colour.YELLOW);
        WritableCellFormat verde = new WritableCellFormat(times16fontNormal);
        verde.setBackground(Colour.DARK_GREEN);

        def label
        def fila = 5;

        label = new Label(2, 2, "REPORTE SEMÁFOROS", times16formatN); sheet.addCell(label);
        label = new Label(1, 3, "", times16formatN); sheet.addCell(label);
        label = new Label(0, 4, "", times16formatN); sheet.addCell(label);
        label = new Label(1, 4, "PROVINCIA", times16format); sheet.addCell(label);
        label = new Label(2, 4, "CANTON", times16format); sheet.addCell(label);
        label = new Label(3, 4, "SEMÁFORO", times16format); sheet.addCell(label);

        def periodos = Periodo.list().sort{it.fechaDesde}

        periodos.eachWithIndex{periodo,i->
            label = new Label(4, 4, periodos.last().fechaDesde?.format("dd-MM-yyyy")?.toString(), times16format); sheet.addCell(label);
            sheet.setColumnView(5+i,15)
            label = new Label(5 + i, 4, periodo?.fechaDesde?.format("dd-MM-yyyy")?.toString(), times16format); sheet.addCell(label);
        }

        def cantones = Canton.list().sort{it.provincia.nombre}

        cantones.eachWithIndex { Canton canton, int i ->
            label = new Label(1, fila,  canton.provincia.nombre.toString(), times16formatN); sheet.addCell(label);
            label = new Label(2, fila,  canton.nombre.toString(), times16formatN); sheet.addCell(label);
            def semaforos = Semaforo.findAllByCanton(canton).sort{it.periodo.fechaDesde}
            semaforos.eachWithIndex {semaforo, j->
                label = new Label(3, fila,  semaforos.last().color?.toString() == '3' ? 'ROJO' : semaforos.last().color?.toString() == '2' ? 'AMARILLO' :'VERDE', times16formatN); sheet.addCell(label);
                label = new Label(4, fila,  semaforos.last()?.color?.toString(), times16formatN); sheet.addCell(label);
                if(semaforo.color?.toString() == '3'){
                    label = new Label(5+j, fila,  semaforo.color?.toString(), rojo); sheet.addCell(label);
                }else{
                    if(semaforo.color?.toString() == '2'){
                        label = new Label(5+j, fila,  semaforo.color?.toString(), amarillo); sheet.addCell(label);
                    }else{
                        label = new Label(5+j, fila,  semaforo.color?.toString(), verde); sheet.addCell(label);
                    }
                }

            }
            fila++
        }
        workbook.write();
        workbook.close();
//        workbook1.write();
//        workbook1.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "reporteSemaforos_" + new Date().format("dd-MM-yyyy") + ".xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def reportes(){

    }


    def circulo () {

//        Workbook wb = new HSSFWorkbook()
//        OutputStream os = new FileOutputStream("Javatpoint.xls")
//        Sheet sheet = wb.createSheet("Sheet");
//        Row row = sheet.createRow(4); // Creating a row
//        Cell cell = row.createCell(1); // Creating a cell
//        HSSFPatriarch patriarch = (HSSFPatriarch) sheet.createDrawingPatriarch();
//        HSSFClientAnchor  a = new HSSFClientAnchor( 0, 0, 1023, 255, (short) 1, 0, (short) 1, 0 );
//        HSSFSimpleShape shape = patriarch.createSimpleShape(a);
//        shape.setShapeType(HSSFSimpleShape.OBJECT_TYPE_OVAL);
//                wb.write(os);



            Workbook workbook = new HSSFWorkbook();
            Sheet sheet = workbook.createSheet("Data Validation");
            HSSFPatriarch patriarch = (HSSFPatriarch) sheet.createDrawingPatriarch();
            HSSFClientAnchor a = new HSSFClientAnchor( 0, 0, 1023, 255, (short) 1, 0, (short) 2, 1 );
            HSSFSimpleShape shape1 = patriarch.createSimpleShape(a);
            shape1.setShapeType(HSSFSimpleShape.OBJECT_TYPE_OVAL);
            shape1.setLineStyleColor(10,10,10);
            shape1.setFillColor(90,10,200);
//            shape1.setLineWidth(HSSFShape.LINEWIDTH_ONE_PT * 3);
//            shape1.setLineStyle(HSSFShape.LINESTYLE_DOTSYS);
            FileOutputStream fileOut = new FileOutputStream("XLDrawingShape.xls");
            try {
                workbook.write(fileOut);
                fileOut.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

    }
}
