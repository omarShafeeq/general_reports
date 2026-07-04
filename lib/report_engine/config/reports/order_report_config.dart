import 'package:flutter/material.dart';

import '../../models/models.dart';

final orderReport = ReportDefinition(
  id: 'order-report',
  title: 'IX Order Overview',
  description: 'Order overview with expandable line-item details',
  category: 'Operations',
  icon: Icons.receipt_long,
  datasource: 'sales-overview',
  viewMode: ReportViewMode.document,
  metadata: const {
    'companyName': 'IX Corporation',
    'address': '123 Main Street',
    'city': 'Anytown, ST 12345',
    'phone': '(555) 123-4567',
    'email': 'info@ix.com',
    'website': 'www.ix.com',
  },
  filters: const [
    FilterDefinition(
      id: 'dateRange',
      label: 'Date Range',
      type: ReportFilterType.dateRange,
    ),
    FilterDefinition(
      id: 'status',
      label: 'Status',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/statuses',
    ),
    FilterDefinition(
      id: 'region',
      label: 'Region',
      type: ReportFilterType.singleSelect,
      apiEndpoint: '/api/regions',
    ),
  ],
  cards: const [
    CardDefinition(
      id: 'totalOrders',
      title: 'Total Orders',
      dataKey: 'totalOrders',
      trendKey: 'totalOrdersTrend',
      icon: Icons.shopping_cart,
      color: Colors.blue,
    ),
    CardDefinition(
      id: 'totalRevenue',
      title: 'Revenue',
      dataKey: 'totalRevenue',
      trendKey: 'totalRevenueTrend',
      icon: Icons.attach_money,
      isCurrency: true,
      color: Colors.green,
    ),
  ],
  grids: const [
    GridDefinition(
      id: 'orderGrid',
      title: '',
      dataKey: 'orderDetails',
      allowFiltering: false,
      allowColumnResize: false,
      columns: [
        GridColumnDefinition(
          field: 'orderDate',
          title: 'Order Date',
          columnType: ColumnType.date,
        ),
        GridColumnDefinition(field: 'invoiceNumber', title: 'Invoice #'),
        GridColumnDefinition(
          field: 'shipDate',
          title: 'Ship Date',
          columnType: ColumnType.date,
        ),
        GridColumnDefinition(field: 'shipmentStatus', title: 'Shipment Status'),
        GridColumnDefinition(
          field: 'total',
          title: 'Order Total',
          columnType: ColumnType.numeric,
          alignment: ColumnAlignment.right,
          formatString: '\$#,##0.00',
        ),
      ],
      sorting: GridSortConfig(field: 'orderDate', ascending: false),
      summaries: [
        GridSummaryConfig(
          field: 'total',
          type: 'sum',
          title: 'Order Total',
        ),
      ],
      nestedGrids: [
        NestedGridDefinition(
          id: 'orderDetailsNested',
          parentKeyField: 'orderId',
          childDatasource: 'order-details',
          childFilterKey: 'orderId',
          gridDefinition: GridDefinition(
            id: 'orderDetailGrid',
            title: '',
            dataKey: 'lines',
            columns: [
              GridColumnDefinition(field: 'product', title: 'Product'),
              GridColumnDefinition(
                field: 'quantity',
                title: 'Qty',
                columnType: ColumnType.numeric,
                alignment: ColumnAlignment.right,
              ),
              GridColumnDefinition(
                field: 'unitPrice',
                title: 'Unit Price',
                columnType: ColumnType.numeric,
                alignment: ColumnAlignment.right,
                formatString: '\$#,##0.00',
              ),
              GridColumnDefinition(
                field: 'discount',
                title: 'Discount',
                columnType: ColumnType.numeric,
                alignment: ColumnAlignment.right,
                formatString: '#0.0%',
              ),
              GridColumnDefinition(
                field: 'total',
                title: 'Line Total',
                columnType: ColumnType.numeric,
                alignment: ColumnAlignment.right,
                formatString: '\$#,##0.00',
              ),
            ],
            summaries: [
              GridSummaryConfig(field: 'quantity', type: 'sum', title: 'Totals'),
              GridSummaryConfig(field: 'total', type: 'sum'),
            ],
          ),
        ),
      ],
      conditionalFormats: [
        GridConditionalFormat(
          field: 'shipmentStatus',
          conditionType: GridConditionType.equals,
          value: 'Delivered',
          style: GridCellStyle(textColor: 0xFF4CAF50),
        ),
        GridConditionalFormat(
          field: 'shipmentStatus',
          conditionType: GridConditionType.equals,
          value: 'Cancelled',
          style: GridCellStyle(textColor: 0xFFF44336, bold: true),
        ),
      ],
    ),
  ],
  sections: const [
    SectionDefinition(id: 'filter-section', type: SectionType.filters),
    SectionDefinition(id: 'grid-section', type: SectionType.grids),
  ],
  exportOptions: const ExportDefinition(
    title: 'IX Order Overview',
    orientation: PageOrientation.portrait,
    header: ExportHeaderConfig(
      showCompanyName: true,
      companyName: 'IX Corporation',
      showReportTitle: true,
      showDate: true,
    ),
    footer: ExportFooterConfig(
      showPageNumber: true,
      showTotalPages: true,
      showDate: true,
    ),
  ),
  toolbar: const ToolbarDefinition(
    showPageNavigation: true,
    showZoom: true,
    showFitPage: true,
    showFitWidth: true,
    showSearch: true,
    showPrint: true,
    showExportPdf: true,
    showExportExcel: true,
    showRefresh: true,
  ),
);
