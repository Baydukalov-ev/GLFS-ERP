#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗагрузитьДанныеИзЧикаго() Экспорт
	
	Если бг_ОбщегоНазначенияСервер.ЭтоРабочаяБаза() Тогда
		
		ВариантОбмена = "Загрузки";
		
		ОбработкаОбъект = Обработки.бг_ЗагрузкаДанныхИзЧикаго.Создать();
		ОбработкаОбъект.Пользователь = Пользователи.ТекущийПользователь();
		ОбработкаОбъект.ИнициализироватьНастройки(ВариантОбмена);
		
		Если ОбработкаОбъект.НастройкаОбменаЗагружена(ВариантОбмена) Тогда
			ОбработкаОбъект.АвтоматическаяЗагрузкаПоРасписанию = Истина;
			ОбработкаОбъект.ВыполнитьОбмен();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли
