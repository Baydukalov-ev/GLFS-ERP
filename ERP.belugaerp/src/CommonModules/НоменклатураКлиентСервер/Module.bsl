
#Область ПрограммныйИнтерфейс

&ИзменениеИКонтроль("ГоденДоПоДатеПроизводства")
Функция бг_ГоденДоПоДатеПроизводства(ДатаПроизводства, СрокГодности, ЕдиницаИзмеренияСрокаГодности) Экспорт
	
	ГоденДо = '00010101';
	
#Удаление
	Если Не ЗначениеЗаполнено(ДатаПроизводства)
		Или Не ЗначениеЗаполнено(СрокГодности) Тогда
		Возврат ГоденДо;
	КонецЕсли;
#КонецУдаления
#Вставка
	Если Не ЗначениеЗаполнено(ДатаПроизводства) Тогда
		Возврат ГоденДо;
	ИначеЕсли ЗначениеЗаполнено(ДатаПроизводства) И Не ЗначениеЗаполнено(СрокГодности) Тогда
		Возврат '39991231';
	КонецЕсли;
#КонецВставки
	
	Если ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Год") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 31536000;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Месяц") Тогда
		ГоденДо = ДобавитьМесяц(ДатаПроизводства, СрокГодности);
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Сутки") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 86400;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности =  ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Час") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 3600;
	КонецЕсли;
	
	Возврат ГоденДо;
	
КонецФункции

#КонецОбласти