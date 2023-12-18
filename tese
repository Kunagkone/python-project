import json
import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
from ttkthemes import ThemedStyle

def add_water_electric():
  def save_bill():
      room = room_entry.get()
      water = int(water_entry.get())
      elect = int(electric_entry.get())
      date = date_entry.get()

      try:
          with open('bill.json') as file:
              bill = json.load(file)

          if 'bill' not in bill:
              bill['bill'] = []

          new_bill = {
              "room_num": room,
              "water": water,
              "electric": elect,
              "pay": False,
              "date": date
          }
          bill["bill"].append(new_bill)

          with open('bill.json', 'w') as file:
              json.dump(bill, file, indent=4)
      except FileNotFoundError:
          messagebox.showerror("Error", "File not found!")

      # Show a messagebox to indicate that the bill has been saved
      messagebox.showinfo("สำเร็จ", "บันทึกเรียบร้อย")

  window = tk.Toplevel(root)
  window.title("เพิ่มค่าน้ำค่าไฟ")
  window.geometry("300x400")  # Set the size of the window

  frame = ttk.Frame(window)
  frame.pack(pady=20)

  room_label = ttk.Label(frame, text="ชื่อห้อง:")
  room_label.grid(row=0, column=0, padx=10)

  room_entry = ttk.Entry(frame)
  room_entry.grid(row=0, column=1, padx=10)

  water_label = ttk.Label(frame, text="ค่าน้ำ:")
  water_label.grid(row=1, column=0, padx=10)

  water_entry = ttk.Entry(frame)
  water_entry.grid(row=1, column=1, padx=10)

  electric_label = ttk.Label(frame, text="ค่าไฟ:")
  electric_label.grid(row=2, column=0, padx=10)

  electric_entry = ttk.Entry(frame)
  electric_entry.grid(row=2, column=1, padx=10)

  date_label = ttk.Label(frame, text="วันที่:")
  date_label.grid(row=3, column=0, padx=10)

  date_entry = ttk.Entry(frame)
  date_entry.grid(row=3, column=1, padx=10)

  button = ttk.Button(window, text="บันทึกข้อมูล", command=save_bill)
  button.pack(pady=10)

  window.mainloop()

def view_all_rooms():
  with open("room.json",encoding='utf-8') as file:
      room_data = json.load(file) 
  root = tk.Tk()
  root.title("แสดงห้องพักทั้งหมด")

  tree = ttk.Treeview(root)
  tree["columns"] = ("price", "vacancy", "tenant_id", "floor")
  tree.heading("#0", text="ห้อง")
  tree.heading("price", text="ราคา")
  tree.heading("vacancy", text="ห้องว่างหรือไม่")
  tree.heading("tenant_id", text="หมาบเลขผู้เช่า")
  tree.heading("floor", text="ชั้น")
  for room in room_data['room']:
      room_number = room['room_num']
      price = room['price']
      vacancy = 'Yes' if room['vacancy'] else 'No'
      tenant_id = room['tenent_id'] if room['tenent_id'] is not None else '--'
      floor = room['floor']

      tree.insert("", tk.END, text=room_number, values=(price, vacancy, tenant_id, floor))

  tree.pack()

  root.mainloop()

def view_all_tenants():
      try:
          with open('tenant.json',encoding='utf-8') as file:
              data = json.load(file)

          # Create a new window
          window = tk.Toplevel(root)
          window.title("เเสดงข้อมูลผู้เช่า")
          window.geometry("900x400")  # Set the size of the window

          # Create a Treeview to display the tenants
          tree = ttk.Treeview(window)
          tree = ttk.Treeview(window)
          tree["columns"] = ("id","id_card", "name", "surname", "age", "city", "line", "contract", "start_date")
          tree.column("#0", width=0, stretch=tk.NO)
          tree.column(0, anchor=tk.CENTER, width=100)
          tree.column(1, anchor=tk.CENTER, width=100)
          tree.column(2, anchor=tk.CENTER, width=100)
          tree.column(3, anchor=tk.CENTER, width=100)
          tree.column(4, anchor=tk.CENTER, width=100)
          tree.column(5, anchor=tk.CENTER, width=100)
          tree.column(6, anchor=tk.CENTER, width=100)
          tree.column(7, anchor=tk.CENTER, width=100)
          tree.column(8, anchor=tk.CENTER, width=100)
          # tree.heading("#0", text="")
          tree.heading(0, text="ลำดับ")
          tree.heading(1, text="เลขบัตรประชาชน")
          tree.heading(2, text="ชื่อ")
          tree.heading(3, text="นามสกุล")
          tree.heading(4, text="อายุ")
          tree.heading(5, text="ที่อยู่")
          tree.heading(6, text="Line")
          tree.heading(7, text="อายุสัญญาเช่า(เดือน)")
          tree.heading(8, text="เริ่มเข้าอยู่")
          

          tenants = data["tenant"]

          for tenant in tenants:
              tree.insert("", tk.END, values=(tenant["id"], tenant["id_card"], tenant["name"], tenant["surname"], tenant["age"], tenant["city"], tenant["line"], tenant["contract"], tenant["start_date"]))

          tree.pack()

      except FileNotFoundError:
          messagebox.showerror("Error", "File not found!")

def sum_bills_by_room(bill_data, room_num):
  electric_total = 0
  water_total = 0

  for bill in bill_data["bill"]:
    if bill["room_num"] == room_num and bill["pay"] == False :
      electric_total += bill["electric"]
      water_total += bill["water"]

  return electric_total, water_total

def sum_bills_by_room_window():
  def display_result():
      room_num = int(room_entry.get())
      with open('bill.json') as file:
          bill_data = json.load(file)
      electric_total, water_total = sum_bills_by_room(bill_data, room_num)
      result_label.config(text=f"ยอดรวมค่าไฟของห้อง  {room_num}: {electric_total} บาท")
      result_label2.config(text=f"ยอดรวมค่าน้ำของห้อง {room_num}: {water_total} บาท")
      result_label3.config(text=f"ยอดรวมค่าใช่จ่ายของห้อง {room_num}: {water_total+electric_total} บาท")

  window = tk.Toplevel(root)
  window.title("คำนวณรายจ่ายห้องเช่า")
  window.geometry("300x200")  # Set the size of the window

  frame = ttk.Frame(window)
  frame.pack(pady=20)

  room_label = ttk.Label(frame, text="โปรดกรอกเลขห้อง:")
  room_label.grid(row=0, column=0, padx=10)

  room_entry = ttk.Entry(frame)
  room_entry.grid(row=0, column=1, padx=10)

  button = ttk.Button(window, text="คำนวณค่าเช่า", command=display_result)
  button.pack(pady=10)

  result_label = ttk.Label(window, text="")
  result_label.pack()

  result_label2 = ttk.Label(window, text="")
  result_label2.pack()
  result_label3 = ttk.Label(window, text="")
  result_label3.pack()
  window.mainloop()

root = tk.Tk()
root.title("ระบบมะซอ เฮาส์")
root.geometry("400x400")

style = ThemedStyle(root)
style.set_theme("arc")

frame = ttk.Frame(root)
frame.pack(pady=20)



view_rooms_button = ttk.Button(frame, text="เเสดงห้องพักทั้งหมด", command=view_all_rooms)
view_rooms_button.grid(row=1, column=0, columnspan=2, pady=10)
view_tenants_button = ttk.Button(frame, text="เเสดงข้อมูลผู้เช่า", command=view_all_tenants)
view_tenants_button.grid(row=2, column=0, columnspan=2, pady=10)
sum_bills_button = ttk.Button(frame, text="คำนวนรายจ่ายห้องเช่า", command=sum_bills_by_room_window)
sum_bills_button.grid(row=3, column=0, columnspan=2, pady=10)
add_bill_button = ttk.Button(frame, text="เพิ่มค่าน้ำค่าไฟ", command=add_water_electric)
add_bill_button.grid(row=6, column=0, padx=10)


root.mainloop()
