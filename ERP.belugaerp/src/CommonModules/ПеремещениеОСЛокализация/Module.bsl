 
 &После("ДобавитьКомандыПечати")
Процедура бг_ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.бг_ПечатьОС";
	КомандаПечати.Идентификатор = "ОС2_Георгиевский";
	КомандаПечати.Представление = НСтр("ru = 'ОС-2 (Накладная на перемещение ОС) ООО ""Георгиевский""';
										|en = 'FA-2 (FA transfer note) LLC ""Georgievsky""'");
	КомандаПечати.ФункциональныеОпции = "ИспользоватьРеглУчет";
			
КонецПроцедуры
