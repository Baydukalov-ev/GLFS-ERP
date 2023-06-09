
&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Сегмент = СегментНабораЗаписей(ЭтотОбъект);		
	ДополнительныеСвойства.Вставить("НоменклатураСегментаСтарая", НоменклатураСегментаВБазе(Сегмент));
	
КонецПроцедуры

Функция НоменклатураСегментаВБазе(Сегмент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураСегмента.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
		|ГДЕ
		|	НоменклатураСегмента.Сегмент = &Сегмент";	
	Запрос.УстановитьПараметр("Сегмент", Сегмент);	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

Функция СегментНабораЗаписей(НаборЗаписей)

	СегментОтбор = НаборЗаписей.Отбор.Найти("Сегмент");
	
	Сегмент = Неопределено;
	Если СегментОтбор <> Неопределено Тогда
		Сегмент = СегментОтбор.Значение;	
	КонецЕсли;
	
	Возврат Сегмент;
	
КонецФункции