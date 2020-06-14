#!/usr/bin/env python3
import os

import qgis.core
from qgis.core import QgsProject, QgsLayoutExporter, QgsApplication

from PyQt5.QtCore import QSettings

class QgisSession:
    """
    QGIS Session context manager
    """
    def __init__(self):
        QgsApplication.setPrefixPath("/usr", True)
        gui_flag = False
        self.app = QgsApplication([], gui_flag)

    def __enter__(self):
        self.app.initQgis()

        # Disable WAL mode so that vector files don't get modified when read
        # https://github.com/qgis/QGIS/issues/23991
        QSettings().setValue("/qgis/walForSqlite3", False)

        return self.app

    def __exit__(self, typ, value, traceback):
        self.app.exitQgis()

def export_map(project_path, layout_name, pdf_path, thumbnail_path):
    # Open project
    project_instance = QgsProject.instance()
    project_instance.setFileName(project_path)
    project_instance.read()

    # Open layout
    manager = QgsProject.instance().layoutManager()
    layout = manager.layoutByName(layout_name)

    # Export PDF
    exporter = QgsLayoutExporter(layout)
    exporter.exportToPdf(
        pdf_path,
        QgsLayoutExporter.PdfExportSettings()
    )

    # Generate a thumbnail image
    image = exporter.renderPageToImage(0, dpi=30)
    image.save(thumbnail_path)


#===============================================================================
if __name__ == "__main__":
    this_dir = os.path.dirname(os.path.abspath(__file__))

    with QgisSession():

        print("Exporting PK-USGS")
        export_map(
            os.path.join(this_dir, 'PysanyjKamin-USGS.qgs'),
            "8.5x11",
            os.path.join(this_dir, "rendered/PysanyjKamin-USGS-8.5x11.pdf"),
            os.path.join(this_dir, "rendered/PysanyjKamin-USGS-8.5x11-thumb.png"),
        )

        print("Exporting PK-greyscale")
        export_map(
            os.path.join(this_dir, 'PysanyjKamin-greyscale.qgs'),
            "8.5x11",
            os.path.join(this_dir, "rendered/PysanyjKamin-greyscale-8.5x11.pdf"),
            os.path.join(this_dir, "rendered/PysanyjKamin-greyscale-8.5x11-thumb.png"),
        )
