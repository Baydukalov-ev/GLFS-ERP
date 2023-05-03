
&После("ПриОпределенииСправочниковХраненияФайлов")
Процедура бг_ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников)
	
	
	МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладелецФайла);
	
	Если МетаданныеВладельца <> Неопределено Тогда
		
		ИмяСтандартногоОсновногоСправочника = "бит" + МетаданныеВладельца.Имя
			+ ?(СтрЗаканчиваетсяНа(МетаданныеВладельца.Имя, "ПрисоединенныеФайлы"), "", "ПрисоединенныеФайлы");
			
		Если Метаданные.Справочники.Найти(ИмяСтандартногоОсновногоСправочника) <> Неопределено Тогда
			ИменаСправочников.Вставить(ИмяСтандартногоОсновногоСправочника, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
