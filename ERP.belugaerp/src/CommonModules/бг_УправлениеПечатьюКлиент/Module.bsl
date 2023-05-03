
#Область ПрограммныйИнтерфейс

Функция ПакетнаяПечатьДокументов(ОписаниеКоманды) Экспорт
	
	НапечататьКомплектДокументов(ОписаниеКоманды.ОбъектыПечати);
				
КонецФункции

Функция ПакетнаяПечатьДокументовСНастройкой(ОписаниеКоманды) Экспорт

	ОткрытьФорму("РегистрСведений.бг_НастройкиПечатиКомплектов.Форма.ФормаЗаписиПроизвольнойНастройки",
		Новый Структура("ОбъектыПечати", ОписаниеКоманды.ОбъектыПечати));
	
КонецФункции

Процедура НапечататьКомплектДокументов(Объекты, НастройкиПечатиОбъектов = Неопределено) Экспорт

	ПараметрыПрограммыПечати = бг_УправлениеНастройкамиДляПечатиФайлов.ПроверитьУстановитьПрограммуПечати();
	Если ПараметрыПрограммыПечати.ОшибкаПодключения Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиПринтера = бг_УправлениеНастройкамиДляПечатиФайлов.НастройкиПринтера(ПараметрыПрограммыПечати);
	Если Не бг_УправлениеНастройкамиДляПечатиФайлов.НастройкаВыполнена(НастройкиПринтера.ОдносторонняяПечать)
		Или Не бг_УправлениеНастройкамиДляПечатиФайлов.НастройкаВыполнена(НастройкиПринтера.ДвусторонняяПечать) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Настройка печати принтера не выполнена. После настройки запустите печать повторно.'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()));
			
		ОткрытьФорму("РегистрСведений.бг_НастройкиПечатиКомплектов.Форма.ФормаНастроекПечатиПринтера");
		Возврат;
		
	КонецЕсли;
	
	КоллекцияПечатныхФормПоОбъектам = бг_УправлениеПечатьюВызовСервера.КоллекцияПечатныхФормПоОбъектам(Объекты, НастройкиПечатиОбъектов);
	ШаблонОшибки = НСтр("ru = 'Не удалось получить комплект печатных форм для объекта %1.'",
							ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
	WSShell = Новый COMОбъект("WScript.Shell");
	ФайлыКПечати = Новый Массив;
	Для Каждого ОписаниеКоллекции Из КоллекцияПечатныхФормПоОбъектам Цикл
		
		ФайлыКПечати.Очистить();
		
		Для Каждого ПечатнаяФорма Из ОписаниеКоллекции.Значение Цикл
			
			Если Не ПечатнаяФорма.ТабличныйДокумент = Неопределено Тогда
				ПечатнаяФорма.ТабличныйДокумент.Напечатать();
			ИначеЕсли ЗначениеЗаполнено(ПечатнаяФорма.ПутьКФайлу) Тогда
				
				ИспользуемаяНастройкаПринтера = НастройкиПринтера.ОдносторонняяПечать;
				Если ПечатнаяФорма.ДвусторонняяПечать Тогда
					ИспользуемаяНастройкаПринтера = НастройкиПринтера.ДвусторонняяПечать;
				КонецЕсли;
					
				ШаблонСкрипта = """%1"" -silent -loaddevmode ""%2"" ""%3""";
				WSShell.Run(СтрШаблон(ШаблонСкрипта, ПараметрыПрограммыПечати.ПолныйПуть, 
					ИспользуемаяНастройкаПринтера, ПечатнаяФорма.ПутьКФайлу), 0, Истина);
				
			Иначе
				
				ШаблонОшибки = НСтр("ru = 'Не удалось сформировать печатную форму %1.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
				ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(ШаблонОшибки, ПечатнаяФорма.ИмяМакета));
				
			КонецЕсли;

		КонецЦикла;
			
	КонецЦикла;
	
	бг_ФиксацияПечатиДокументовКлиент.ЗафиксироватьПечатьКомплектаДокументов(
		КоллекцияПечатныхФормПоОбъектам);
	
КонецПроцедуры

#КонецОбласти