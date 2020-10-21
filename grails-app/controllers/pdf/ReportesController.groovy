package pdf

import geografia.Canton
import geografia.Provincia
import jxl.WorkbookSettings
import jxl.write.Label
import jxl.write.WritableCellFormat
import jxl.write.WritableFont
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import monitor.Periodo
import monitor.Semaforo
import org.apache.poi.ss.usermodel.ConditionalFormattingRule
import org.apache.poi.ss.usermodel.SheetConditionalFormatting
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFClientAnchor
import org.apache.poi.xssf.usermodel.XSSFDrawing
import org.apache.poi.xssf.usermodel.XSSFSimpleShape

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

//        SheetConditionalFormatting sheetCF = sheet.getSheetConditionalFormatting();
//        ConditionalFormattingRule rule = sheetCF.createConditionalFormattingRule(IconMultiStateFormatting.IconSet.GYR_3_TRAFFIC_LIGHTS);
//        rule.getMultiStateFormatting().setIconOnly(true);
//
//        ConditionalFormattingRule [] cfRules = {rule};
//
//        CellRangeAddress[] regions = {CellRangeAddress.valueOf("A1:A3")};
//
//        sheetCF.addConditionalFormatting(regions, cfRules);

//        XSSFSimpleShape shape = ((XSSFDrawing)drawing).createSimpleShape((XSSFClientAnchor)anchor);
//        shape.setShapeType(ShapeTypes.ELLIPSE);
//        shape.setFillColor(255, 0, 0);


        // fija el ancho de la columna
        sheet.setColumnView(0,5)
        sheet.setColumnView(1,20)
        sheet.setColumnView(2,30)
        sheet.setColumnView(3,15)
        sheet.setColumnView(4,15)
//        sheet.setColumnView(5,15)

        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, false);
        WritableFont times16fontNormal = new WritableFont(WritableFont.TIMES, 11, WritableFont.NO_BOLD, false);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        WritableCellFormat times16formatN = new WritableCellFormat(times16fontNormal);

//        autoSizeColumns(sheet, 10)

        def label
        def fila = 5;

        label = new Label(1, 2, "REPORTE SEMÁFOROS", times16format); sheet.addCell(label);
        label = new Label(1, 3, "", times16format); sheet.addCell(label);
        label = new Label(0, 4, "", times16format); sheet.addCell(label);
        label = new Label(1, 4, "PROVINCIA", times16format); sheet.addCell(label);
        label = new Label(2, 4, "CANTON", times16format); sheet.addCell(label);
        label = new Label(3, 4, "SEMÁFORO", times16format); sheet.addCell(label);
//        label = new Label(4, 4, "PERÍODO 0", times16format); sheet.addCell(label);

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
                label = new Label(5+j, fila,  semaforo.color?.toString(), times16formatN); sheet.addCell(label);
            }
            fila++
        }
        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "reporteSemaforos_" + new Date().format("dd-MM-yyyy") + ".xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def reportes(){

    }
}
