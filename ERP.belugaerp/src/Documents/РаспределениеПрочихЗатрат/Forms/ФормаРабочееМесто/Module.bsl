#Область ОписанияЗаданий

&Вместо("ПодготовитьКлиентскиеПараметрыЗаданий")
&НаКлиенте
Функция бг_ПодготовитьКлиентскиеПараметрыЗаданий()
	ПараметрыЗаданий = ПродолжитьВызов();
	
	Для Каждого ПараметрЗадания Из ПараметрыЗаданий Цикл
		Если ПараметрЗадания.Ключ = "СформироватьДокументы" Тогда
			ПараметрЗадания.Значение.Вставить("бг_ЗаполнитьОтборПоПродукции", Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыЗаданий;
КонецФункции

#КонецОбласти
