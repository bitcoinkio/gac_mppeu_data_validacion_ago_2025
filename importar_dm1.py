import pandas as pd
import mysql.connector
from mysql.connector import Error

# Configuración de conexión MySQL
config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Yandex$5',
    'database': 'ValidacionIPASME_MPPE'
}

def importar_dm1_csv():
    try:
        # Leer archivo CSV
        print("Leyendo archivo CSV...")
        archivo_csv = r"C:\Program Files\MySQL\MySQL Server 8.0\uploads\dm1_mppe.csv"
        
        # Leer CSV con pandas
        df = pd.read_csv(archivo_csv, encoding='utf-8')
        
        print(f"Archivo leído exitosamente: {len(df)} registros")
        
        # Conectar a MySQL
        print("\nConectando a MySQL...")
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        
        # Limpiar tabla
        print("Limpiando tabla...")
        cursor.execute("TRUNCATE TABLE dm1_fijos_contratados_mppe")
        
        # Preparar query de inserción
        insert_query = """
        INSERT INTO dm1_fijos_contratados_mppe 
        (entidad, cedula, nombre_completo, cargo, cargo_f, fecha_nacimiento, sexo, tipo_persona, status_empleado)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        # Procesar datos en lotes
        batch_size = 1000
        total_registros = len(df)
        
        print(f"\nInsertando {total_registros} registros...")
        
        for i in range(0, total_registros, batch_size):
            batch = df.iloc[i:i+batch_size]
            
            datos_lote = []
            for _, row in batch.iterrows():
                fecha_nac = None
                if pd.notna(row.get('F. NACIMIENTO')):
                    try:
                        fecha_nac = pd.to_datetime(row['F. NACIMIENTO']).strftime('%Y-%m-%d')
                    except:
                        fecha_nac = None
                
                datos_lote.append((
                    str(row.get('ENTIDAD', '')),
                    str(row.get('CEDULA', '')),
                    str(row.get('NOMBRE', '')),
                    str(row.get('CARGO', ''))[:250],
                    str(row.get('CARGO', ''))[:250],
                    fecha_nac,
                    str(row.get('SEXO', ''))[:1],
                    str(row.get('TPERSONA', ''))[:10],
                    str(row.get('STATUS', ''))[:10]
                ))
            
            cursor.executemany(insert_query, datos_lote)
            connection.commit()
            
            progreso = i + len(datos_lote)
            porcentaje = (progreso / total_registros) * 100
            print(f"Progreso: {progreso}/{total_registros} ({porcentaje:.1f}%)")
        
        print(f"\n✅ IMPORTACIÓN EXITOSA!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    importar_dm1_csv()